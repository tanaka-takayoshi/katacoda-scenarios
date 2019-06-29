Dockerfileを使ってDockerイメージを作成し、実行します。

# Dockerfileの編集

以下のファイルを開き、下の内容をペーストします。

`MyWebApp/Dockerfile`{{open}}

<pre class="file" data-target="clipboard">
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base

WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS publish
WORKDIR /src
COPY . .
RUN dotnet publish MyWebApp.csproj -c Release -o /app

FROM base As final
WORKDIR /app
COPY --from=publish /app /app
ENTRYPOINT [ "dotnet", "MyWebApp.dll" ]
</pre>

# Dockerイメージのビルド

次のコマンドでDockerイメージをビルドします。`-t`は作成するイメージにつけるタグです。

`docker build -t mywebapp  .`{{execute}}

# Dockerイメージの実行

次のコマンドで作成したイメージを実行します。

`docker run mywebapp`{{execute}}

なお上のコマンドではコンテナ外部からアプリにアクセスできません。これはKatacodeのイメージの仕様によるものです。
そのほかの環境を利用している場合、`-p`オプションをつけることでコンテナホストのポートとコンテナないのポートをマッピングできます。
これにより、コンテナホストのポート80にアクセスするとコンテナのポート80にアクセスできます。

`docker run -p 80:80 mywebapp`

もしコンテナホストですでにポート80を使っている場合は別のポートに変更できます。例えばポート8123をコンテナのポート80にマッピングさせる場合は次のコマンドを実行します。

`docker run -p 8123:80 mywebapp`

コンテナは起動したまま次のステップに進んでください。