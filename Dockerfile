# syntax=docker.io/docker/dockerfile:1

FROM public.ecr.aws/docker/library/golang:1.21.4-alpine3.18 AS base

ARG TARGETARCH

FROM base AS builder

WORKDIR /app

RUN apk add --no-cache git make

COPY . .

RUN make build

FROM scratch AS dist

COPY --from=builder /app/bin .
