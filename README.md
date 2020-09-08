# This is old version. Please, find the actual version [here](https://github.com/puzl-ee/docker-images/tree/dev/images/xgboost).

XGBoost library wtih Tensorflow 2 and various python runtime. Used by puzl.ee Kubernetes cloud.

#### Build:

```
docker build \
    --build-arg INTERPRETER=python3.8 \
    -t puzlcloud/xgboost:python3.8 .
```
