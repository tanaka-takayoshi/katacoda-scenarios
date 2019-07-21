# kubernetesのオブジェクトをYAMLで定義する

先ほどはkubectlコマンドを使ってポッドとサービスを作成しましたが、利用できるオプション全てがコマンドから設定できる訳ではありません。
また、互いに関連する複数のオブジェクトを作成する場合などには複数のオブジェクトをまとめて定義したい場合があります。
このような場合、オブジェクトの定義をファイルで記述することができます。
JSON形式でも定義できますが、タイプ量が少なくなるYAML形式がより多く使われているようです。

そこでYAMLファイルを作成します。

`touch mywebapp.yaml`{{execute}}

作成したファイルをエディターで開き、その下のYAMLの記述をコピーペーストしてください。

`MyWebApp/mywebapp.yaml`{{open}}

<pre class="file" data-target="clipboard">
apiVersion: apps/v1 
kind: Deployment
metadata:
  name: mywebapp-deployment
spec:
  selector:
    matchLabels:
      app: mywebapp
  replicas: 1
  template:
    metadata:
      labels:
        app: mywebapp
    spec:
      containers:
      - name: mywebapp
        image: mywebapp:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: mywebapp
  name: mywebapp
spec:
  ports:
  - nodePort: 32565
    port: 18081
    protocol: TCP
    targetPort: 80
  selector:
    app: mywebapp
  sessionAffinity: None
  type: NodePort
</pre>

ファイルの内容からオブジェクトを作成する次のコマンドを実行してください。

`kubectl create -f mywebapp.yaml`{{execute}}

実際に作成されたオブジェクトを確認するには次のコマンドを実行します。

`kubectl get all`{{execute}}

また、何が作成されるかわかっている場合、オブジェクトの種類を並べることもできます。

`kubectl get pod,svc`{{execute}}

さきほどと同じようにCLUSTER-IPとPORTの組み合わせでアクセスすることができます。

`curl 10.105.95.136:18080`

# kubernetesのオブジェクトを編集する

作成したオブジェクトに変更を加えることもできます。全てのパラメーターを作成後に変更できるわけではありませんが、例えば1つのDeploymentで作成するPodの数を増やすことができます。
すなわち、手動でアプリケーションをスケーリングすることができます。

次のコマンドを実行すると、ターミナルでエディタが開きオブジェクトを編集できます。通常は`KUBE_EDITOR`環境変数にお気に入りのエディタを登録するのがよいでしょう。katacode環境ではvimではうまく表示されないことがあったため、nanoを使っています。また非常にレスポンスが悪いため注意して操作してください。

`KUBE_EDITOR=nano kubectl edit deployment mywebapp-deployment`{{execute}}

次のようになっている箇所を見つけ、`replicas`を3に変更します。

```
  spec:
    selector:
      matchLabels:
        app: mywebapp
    replicas: 3
```


`CTRL+X`をタイプして`Y`とタイプし、`Enter`キーを押すとと保存されエディタが終了します。もし、妥当でないフォーマットだったり、妥当でない変更（変更不可能なパラメーターを変更するなど）があった場合、エラーとなりもう一度編集画面に戻ります。
無事にエディタが終了して変更されたら、Podが増える様子を確認して見ましょう。

`kubectl get pod -w`{{execute}}

```
 kubectl get pod -w
NAME                                 READY   STATUS    RESTARTS   AGE
mywebapp                             1/1     Running   0          6m49s
mywebapp-deployment-b9cbf596-62mss   1/1     Running   0          5m16s
mywebapp-deployment-b9cbf596-cz86b   1/1     Running   0          8s
mywebapp-deployment-b9cbf596-t2rqc   1/1     Running   0          8s
```

先ほどアクセスしたURLで同じようにアクセスされます。
この時、見た目ではわかりませんが3つのPodにリクエストは振り分けられています。Serviceは起動しているPodにのみリクエストを振り分けるので、適当なPodを削除すると、そのPodへはリクエストは割り振られず、新しいPodが作成されるとそのPodに割り振られるようになります。

