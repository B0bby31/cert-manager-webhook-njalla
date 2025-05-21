FROM golang:1.22-alpine AS build
WORKDIR /build
COPY src/ .
RUN CGO_ENABLED=0 go build -ldflags '-w -extldflags "-static"' .

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=build /build/cert-manager-webhook-njalla /usr/local/bin/
RUN chmod +x /usr/local/bin/cert-manager-webhook-njalla
ENTRYPOINT ["/usr/local/bin/cert-manager-webhook-njalla"]
