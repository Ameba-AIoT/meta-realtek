#!/bin/sh

rm priv.pem swupdate-public.pem
openssl genrsa -out priv.pem
openssl rsa -in priv.pem -out swupdate-public.pem -outform PEM -pubout

