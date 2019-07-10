# kubernetesのオブジェクトをYAMLで定義する

先ほどはkubectlコマンドを使ってポッドとサービスを作成しましたが、利用できるオプション全てがコマンドから設定できる訳ではありません。
また、互いに関連する複数のリオブジェクトを作成する場合などには複数のオブジェクトをまとめて定義したい場合があります。
このような場合、オブジェクトの定義をファイルで記述することができます。
JSON形式でも定義できますが、タイプ量が少なくなるYAML形式がより多く使われているようです。

そこでYAMLファイルを作成します。

{{touch MyWebApp/mywebapp.yaml}}

次のコマンドでファイルをエディターで開き、その下のYAMLの記述をコピーペーストしてください。

{{MyWebApp/mywebapp.yaml}}{{open}}

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

`kubectl create -f myqebapp.yaml`{{execute}}

`kubectl get all`{{execute}}

`kubectl get pod,svc`{{execute}}

# kubernetesのオブジェクトを編集する

`kubectl edit deployment mywebapp`{{execute}}

```
spec:
  selector:
    matchLabels:
      app: mywebapp
  replicas: 3
```

