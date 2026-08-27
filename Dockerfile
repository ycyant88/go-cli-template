# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/dev1-sg/alpine/golang:1.25.0 AS base

ARG TARGETARCH

FROM base AS builder

COPY . .

RUN apk add --no-cache make && make build

FROM scratch AS dist

COPY --from=builder /go/bin .

FROM base AS push

WORKDIR /app

COPY  "dist/*_linux_${TARGETARCH}.tar" .

RUN tar -xvf *.tar
