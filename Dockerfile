FROM golang:1.22-alpine AS build
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 go build -ldflags '-w -extldflags "-static"' .

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=build /build/cert-manager-webhook-njalla /local/bin
ENTRYPOINT ["cert-manager-webhook-njalla"]
