This is your first step.

# プロジェクトの作成

`dotnet new web -o MyWebApp`{{execute}}


# プロジェクトの起動

`cd MyWebApp`{{execute}}

アプリケーションの発行をします。

`dotnet publish`{{execute}}

このままのデフォルト設定では外部から接続できないので、環境変数を設定し、外部からの接続を許可しポートも変更します。

`export ASPNETCORE_URLS=http://+:80`{{execute}}

実行します。

`dotnet bin/Debug/netcoreapp2.2/publish/MyWebApp.dll`{{execute}}

新しいターミナルを開いて実行するとアクセスできます。

`curl localhost:80`{{execute}}

外部からアクセスしたい場合、Katacodeで動いているこのホストはインターネットに直接公開されてはいないのでそのままではアクセスできません。
その代わりに以下のURLでプロキシを介して接続できます。

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com

元のターミナルに戻って`CTRL+C`でプロセスを終了します。