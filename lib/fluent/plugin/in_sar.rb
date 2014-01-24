class SarInput < Fluent::Input
    Fluent::Plugin.register_input('sar', self)

    config_param :sar_option,       :string,  default: ''
    config_param :tag,              :string,  default: 'sar_result.tag'
    config_param :interval,         :integer, default: 5
    config_param :hostname_output,  :bool,    default: true 
    config_param :hostname,         :string,  default: Socket.gethostname

    def configure(conf)
        super
        @interval_m = @sar_option.split.size.zero? ? @interval * 60 : @interval * 60 - 1
        begin
           `sar -V`
           raise Fluent::ConfigError, "sar_option contains illegal characters.(sar_option: #{@sar_option})" if /[^a-zA-Z ]+/ =~ @sar_option
        rescue
           raise Fluent::ConfigError, "sar(sysstat) is not installed."
        end
    end

    def start
        super
        @thread = Thread.new(&method(:run))
    end

    def shutdown
        @thread.kill
    end

    private

    def run
        loop do
            @result             = Hash.new
            @result["hostname"] = @hostname if @hostname_output
            Fluent::Engine.emit(@tag, Fluent::Engine.now, @result.merge(sar_execute(@sar_option.split)))
            sleep @interval_m
        end
    end

    def sar_execute(opt_ary)

        rlt = Hash.new{| k, v | Hash[k] = Hash.new }
        rec = Hash.new
        th  = Array.new

        opt_ary.each {| opt |
            th << Thread.new {
                i = 0
                `LANG=C sar -#{opt} 1 1 | grep -vi average | tail -n2`.split("\n").each{| a | rlt[(i += 1)] = a.split }
                rlt[1][0].sub!(/[0-9]{2}\:[0-9]{2}\:[0-9]{2}/, "check_time")
                rec.merge!(Hash[*rlt[1].zip(rlt[2]).flatten])
            }
        }
        th.each {| t | t.join }

        rec
    end
end

