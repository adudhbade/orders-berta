FROM golang:1.10 as builder
ARG DOCK_PKG_DIR=/go/src/github.com/adudhbade/orders-berta/
ADD . $DOCK_PKG_DIR
WORKDIR $DOCK_PKG_DIR
RUN go get -t -d -v -insecure ./...
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
RUN go test ./...


FROM scratch
LABEL source=git@github.com:adudhbade/orders-berta
WORKDIR /app/
COPY --from=builder /go/src/github.com/adudhbade/orders-berta/main /app/
COPY --from=builder /go/src/github.com/adudhbade/orders-berta/docs/api/api.yaml /app/
CMD ["./main"]

EXPOSE 8017:8017
