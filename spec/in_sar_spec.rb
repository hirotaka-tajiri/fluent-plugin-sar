# encoding: UTF-8
require_relative 'spec_helper'
describe "SarInput" do

    before { Fluent::Test.setup }

    CONFIG = %[
        type              sar
        sar_option        u q r b w B R S v W
        tag               sar.tag
        interval          10
        hostname_output   false
        hostname          test_node
    ]
    CONF_D = %[
        type sar
        sar_option         u
    ]
    CNF_I1 = %[
        type sar
        sar_command_path  /usr/bin/sar
        sar_option |
    ]
    CNF_I2 = %[
        type sar
        sar_command_path  /usr/bin/sar
        sar_option |;
    ]
    CNF_I3 = %[
        type sar
        sar_command_path  /usr/bin/sar
        sar_option a ;rm b
    ]

    def create_driver(conf)
        Fluent::Test::InputTestDriver.new(SarInput).configure(conf)
    end

  describe "config test" do

        let(:driver)  { Fluent::Test::InputTestDriver.new(SarInput).configure(CONFIG) }
        let(:driver1) { Fluent::Test::InputTestDriver.new(SarInput).configure(CONF_D) }

    context "Test config F " do
        subject { driver.instance }
        its (:sar_option)       { should eq "u q r b w B R S v W" }
        its (:tag)              { should eq "sar.tag" }
        its (:interval)         { should eq 10 }
        its (:hostname_output)  { should eq false }
        its (:hostname)         { should eq "test_node"}
    end

    context "Test config defalut " do
        subject { driver1.instance }
        its (:sar_option)       { should eq 'u' }
        its (:tag)              { should eq 'sar_result.tag' }
        its (:interval)         { should eq 5 }
        its (:hostname_output)  { should eq true }
        its (:hostname)         { should eq Socket.gethostname}
    end

    context "Test config raise error" do
        it { expect(lambda{create_driver(CNF_I1)}).to raise_error(Fluent::ConfigError) }
        it { expect(lambda{create_driver(CNF_I2)}).to raise_error(Fluent::ConfigError) }
        it { expect(lambda{create_driver(CNF_I3)}).to raise_error(Fluent::ConfigError) }
    end
  end
end
