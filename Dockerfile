FROM golang:alpine as builder 

#set req env varss needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
		GOOS=linux \
		GOARCH=amd64

# Move to working dir /build
WORKDIR /build

# Copy and download dependancy using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download


# Copy code into the container
COPY . .


# Build the application
RUN go build -o main

# move working dir to dist
WORKDIR /dist

# Move to /dist dir as the place for resulting binary folder
RUN cp /build/main .

# build small image
FROM scratch

COPY --from=builder /dist/main /

# cmd to run
ENTRYPOINT ["/main"] 
