# Fluent::Plugin::Sar

Fluentd input plugin to get sar result

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-sar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-sar

## Overview

This plugin collect "sar command result" every (interval) minutes.

## Configuration
### Parameters:

+ sar_command_path


    (required)
    
    your server's "sar" command path

+ sar_option


    (required)
    
    same sar option, but not all.

    e.g.) sysstat version 9.0.4 on CentOS 6.5
   Support
    b     Report I/O and transfer rate statistics.  
    B     Report paging statistics. Some of the metrics below are available only with post 2.5 kernels. 
    m     Report power management statistics.  Note that these statistics depend on sadc option "-S POWER"  to  be  collected. 
    q     Report queue length and load averages.
    r     Report memory utilization statistics.  
    R     Report memory statistics. 
    S     Report swap space utilization statistics.
    u     Report  CPU  utilization.
    v     Report status of inode, file and other kernel tables.
    w     Report task creation and system switching activity.
    W     Report swapping statistics.


   Not support
   
        A
        C    
        d
        I     
        j
        n
        P
        p         
        y

- tag 


    (optional | default : "sar_result.tag")

- interval


    (optional | defalut : 5)
    
    every (interval) minutes.

- hostname_output


    (optional | defalut : True)
    
    true or false

- hostname


    (optionl |  defalut : your server's hostname)

### Example:

    <source>
        type              sar
        sar_command_path  /usr/bin/sar
        sar_option        u q
        tag               sar.tag
        interval          10
        hostname_output   true
        hostname          check_host01
    </source>

output

    sar.tag: {"hostname":"check_host01","check_time":"18:51:25","runq-sz":"0","plist-sz":"223","ldavg-1":"0.00","ldavg-5":"0.00","ldavg-15":"0.00","CPU":"all","%user":"0.00","%nice":"0.00","%system":"1.03","%iowait":"0.00","%steal":"0.00","%idle":"98.97"}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2014 Hirotaka Tajiri. See [LICENSE](LICENSE.txt) for details.
