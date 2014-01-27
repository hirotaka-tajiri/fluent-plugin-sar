# Fluent::Plugin::Sar

sarの結果を取得するFluentdのinput pluginです。
sysstatがインストールされていることが、このプラグインの動作条件です。

## インストール

bundlerでインストールする場合
下記を記載したGemfileを用意して:

    gem 'fluent-plugin-sar'

下記コマンドを実行します。:

    $ bundle

bundlerを使用せず、自身でgemコマンドを実行する場合には
下記コマンドを実行してください。:

    $ gem install fluent-plugin-sar

## 概要

このプラグインは"sarの実行結果"を設定した間隔毎に収集します。


## 設定
### パラメーター:

+ sar_option


    (必須項目)
    
    sarコマンドを実行しているだけなので、sarのコマンドオプションがそのまま使え、
    スペース区切りで複数同時に指定出来ます。
    ただし、出力結果のパースに対応できていないオプションがあります。
    パースが対応できないオプションは、sarの実行結果が複数行になるものです。
    また、サブオプションをとるオプションについても実行時のパースで対応していません。

    具体例) OSがCentOS 6.5でsysstat version 9.0.4 の環境で確認した、対応可能と未対応のオプション

   対応可能:

        b     I/O と転送率の状況
        B     ページングの状態
        m     電力管理状況 
        q     Qキューの長さとロードアベレージの状態
        r     メモリ利用率の状態  
        R     メモリの状況
        S     スワップ領域の利用状況
        u     CPU 利用の利用状況(省略出力)
        v     カーネルのテーブル状態
        w     タスクの作成とシステムスイッチの状態
        W     スワップの状態

   未対応:

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


    (任意項目 | 既定値 : "sar_result.tag")

- interval


    (任意項目 | 既定値 : 5)

    設定分毎にsarを実行します。

- hostname_output


    (任意項目 | 規定値 : True)

    出力レコードにホスト名を追加するかどうかを選択できます。
    出力する(true)/出力しない(false)で設定します。

- hostname


    (任意項目 | 規定値 : OS設定のホスト名)

    ホスト名を出力するに設定した場合、自動でOS設定のホスト名を取得します。
    OS設定のホスト名とは別の名前で出力したい場合は、任意の名前を設定するも可能です。

### 設定例

    <source>
        type              sar
        sar_option        u q
        tag               sar.tag
        interval          10
        hostname_output   true
        hostname          check_host01
    </source>

出力結果

    sar.tag: {"hostname":"check_host01","check_time":"18:51:25","runq-sz":"0","plist-sz":"223","ldavg-1":"0.00","ldavg-5":"0.00","ldavg-15":"0.00","CPU":"all","%user":"0.00","%nice":"0.00","%system":"1.03","%iowait":"0.00","%steal":"0.00","%idle":"98.97"}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2014 Hirotaka Tajiri. See [LICENSE](LICENSE.txt) for details.
