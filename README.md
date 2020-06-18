XGBoost library wtih Tensorflow 2 and various python runtime. Used by puzl.ee Kubernetes cloud.

#### Build:

```
docker build \
    --build-arg INTERPRETER=python3.8 \
    -t puzlcloud/xgboost:python3.8 .
```
