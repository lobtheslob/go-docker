FROM golang:alpine 

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

# Export 3000

EXPOSE 3000

# Command to run when starting the container
CMD ["/dist/main"]
