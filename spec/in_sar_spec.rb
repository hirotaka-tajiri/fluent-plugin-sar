# encoding: UTF-8
require_relative 'spec_helper'
describe "SarInput" do

    before { Fluent::Test.setup }

    CONFIG = %[
        type              sar
        sar_command_path  /usr/bin/sar
        sar_option        u q r b w B R S v W
        tag               sar.tag
        interval          10
        hostname_output   false
        hostname          test_node
    ]
    CONF_D = %[
        type sar
        sar_command_path  /usr/bin/sar
    ]
    CONF_E = %[
        type sar
    ]
    CONF_F = %[
        type sar
        sar_command_path  /usr/local/bin/sar
    ]
  

  describe "config test" do

        let(:driver)  { Fluent::Test::InputTestDriver.new(SarInput).configure(CONFIG) }
        let(:driver1) { Fluent::Test::InputTestDriver.new(SarInput).configure(CONF_D) }
        let(:driver2) { Fluent::Test::InputTestDriver.new(SarInput).configure(CONF_E) }
        let(:driver3) { Fluent::Test::InputTestDriver.new(SarInput).configure(CONF_F) }

    context "Test config F " do
        subject { driver.instance }
        its (:sar_command_path) { should eq "/usr/bin/sar" }
        its (:sar_option)       { should eq "u q r b w B R S v W" }
        its (:tag)              { should eq "sar.tag" }
        its (:interval)         { should eq 10 }
        its (:hostname_output)  { should eq false }
        its (:hostname)         { should eq "test_node"}
    end

    context "Test config defalut " do
        subject { driver1.instance }
        its (:sar_command_path) { should eq "/usr/bin/sar" }
        its (:sar_option)       { should eq '' }
        its (:tag)              { should eq 'sar_result.tag' }
        its (:interval)         { should eq 5 }
        its (:hostname_output)  { should eq true }
        its (:hostname)         { should eq Socket.gethostname}
    end

    context "Test config raise error" do
        it { lambda{ driver2 }.should raise_error(Fluent::ConfigError) }
        it { lambda{ driver3 }.should raise_error(Fluent::ConfigError) }
    end
  end
end
