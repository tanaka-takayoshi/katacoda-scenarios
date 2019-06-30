いくつかのdockerコマンドの使い方を紹介します。
コンテナを起動したターミナルとは別のターミナルで実行してください。

# 起動中のdockerコンテナを調べる

起動中のdockerコンテナ一覧を表示します。

`docker ps`

なお、Katacodeで使っている環境はkubernetes用の環境なので、すでに別のコンテナが多数動いています。次のコマンドで欲しいプロセスだけを表示します。

`docker ps | grep dotnet`{{execute}}

次のように出力されるはずです。`440359979bf4`が動いているコンテナのIDで以降のコマンドで指定します。

```
440359979bf4        mywebapp                "dotnet MyWebApp.dll"    15 seconds ago      Up 14 seconds      80/tcp              unruffled_edison
```


# 起動中のコンテナのログを確認する

コンテナ内のプロセスが標準出力に出したログを確認できます。<containerID>を先ほどのIDと置き換えて実行してください。

`docker logs <containerID>`


# コンテナ内に入ってコマンドを実行する

LinuxサーバーにSSHするイメージで使えます。コンテナにアクセスできるようにするのはセキュリティ上強く非推奨です。

`docker exec -it <containerID> /bin/bash`

コマンドを実行するだけでよければこのように実行できます。自動化スクリプトなどではこちらの方が使いやすいでしょう。

`docker exec <containerID> cat /app/appsettings.json`

# コンテナプロセスの停止

コンテナで起動したプロセスが終了したらコンテナも終了しますが、手動で停止したい場合は次のコマンドを実行します。

`docker kill <containerID>`

実際に実行した後、docker runを実行したターミナルに戻るとプロセスが終了していることが確認できます。

# 起動時に環境変数を指定する

`-e`オプションでコンテナ内に渡す環境変数を指定できます。

`docker run -e MYVAR1=VALUE1 mywebapp`{{execute}}

実際に実行したら、新しいcontainerIDを確認してから、envコマンドで実際に指定されていることを確認してみましょう。

`docker ps | grep dotnet`{{execute}}

`docker exec <containerID> env | grep MYVAR1`

その他にもホスト側のファイルシステムを参照することができたりします。