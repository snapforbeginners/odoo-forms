# pulsar Datatypes

This builds on
[`pulsar-postgres`](https://github.com/snapforbeginners/pulsar-postgres)
to create a set of datatypes we will use to insert and retrieve data
from Postgres.

# Using the Image

The Image is available on the docker registry along with a pre-set up
Postgres image:

```
docker pull snapforbeginners/pulsar-datatypes:pulsar
docker pull snapforbeginners/pulsar-datatypes:postgres
```

First, bring up the Postgres container with a name:

```
docker run -it --name pulsar-pg snapforbeginners/pulsar-datatypes:postgres
```

Then use that name (`pulsar-pg`) to link the running postgres container
to our application, under the alias "postgres". We'll also expose port
`8000`, since pulsar runs on that port.

```
docker run -it --link pulsar-pg:postgres -p 8000:8000 snapforbeginners/pulsar-datatypes:pulsar
```

# Building

We can use docker-compose to build and run both containers:

```bash
docker-compose build
docker-compose up -d pg
docker-compose up pulsar
```

# Building individually:

To build a new image, we need to clone this repository and run `docker build`.

```
git clone git@github.com:snapforbeginners/datatypes.git pulsar-datatypes
cd pulsar-datatypes
docker build -t pulsar-dt .
```

then we can run it as before:

```
docker run -it -p 8000:8000 pulsar-dt
```

