push docker image

# kubernetes クラスタの情報

この環境には単一ノードのkubernetesクラスターが準備済みです。kubernetesは1つ以上のノードから構成され、ポッドと呼ばれる単位でコンテナイメージをノードの上で動かします。

ノードの状態を確認するには次のコマンドを実行します。

`kubectl get node`{{execute}}

もし、STATUSが`NotReady`と表示された場合は`kubectl get node -w`と-wオプションをつけてReadyになるまで待ってください。

```
NAME     STATUS     ROLES    AGE   VERSION
master   NotReady   master   19s   v1.14.0
```

```
NAME     STATUS   ROLES    AGE   VERSION
master   Ready    master   23s   v1.14.0
```

`-w`オプションはgetコマンドで取得する状態に変更があったら通知してくれるので、何か操作した後に状態が変わるまで確認したい時に便利です。

より詳細なノードの状態を確認したい場合は次のコマンドを実行します。
`kubectl describe node`{{execute}}

# コンテナのデプロイ

kubernetesはポッドという単位でコンテナイメージを配置して動かします。ポッドは一つ以上のコンテナイメージから構成されます。
今回のハンズオンでは、1つのコンテナイメージから構成されるポッドのみを扱うので、「ポッド=コンテナ=アプリケーションの動く単位」と考えて良いです。

それでは前の手順で作成した.NET Coreのコンテナイメージをkubernetesj場で動かしてみましょう。なお、このコマンドはコンテナイメージをあらかじめ作成しておかないと動きません。

`kubectl run mywebapp --generator=run-pod/v1 --image-pull-policy='Never' --port=80 --image=mywebapp`{{execute}}

> **_NOTE:_** 
このコマンドでは、先ほどdocker buildしたイメージを参照しています。そのため、docker buildしておらずmywebappというイメージが存在しない環境では動きません。
kubernetesを複数ノードで動かしている場合、全てのノードでビルドしないと動かないことになります。
そのため、通常kubernetesにデプロイするコンテナイメージはdockerHubのようなコンテナイメージリポジトリを参照して配置します。

次のコマンドで配置したポッドの状態を確認します。
`kubectl get po`{{execute}}

```
NAME       READY   STATUS    RESTARTS   AGE
mywebapp   1/1     Running   0          71s
```

さて、これだけではこのコンテナにコンテナの外からアクセスすることはできません。
kubernetesではサービスというオブジェクトを作り、コンテナへのアクセスを管理します。
内部ロードバランサーというイメージに近いかもしれません。
次のコマンドでサービスを作成します。

`kubectl expose pod mywebapp --type=NodePort  --port=18080 --target-port=80`{{execute1}}

作成したサービスの状態を確認します。
`kubectl get svc`{{execute}}

```
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP    28m
mywebapp     ClusterIP   10.99.45.161   <none>        8080/TCP   4s
```

