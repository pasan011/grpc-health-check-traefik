package main

import (
	"context"
	health "gprc_server/proto/health_check"
	"log"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

func main() {

	lis, err := net.Listen("tcp", ":3333")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	grpcServer := grpc.NewServer()

	reflection.Register(grpcServer)

	healthSrvr := &HealthSrvc{}
	health.RegisterHealthServer(grpcServer, healthSrvr)

	log.Printf("server listening at %v", lis.Addr())
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

type HealthSrvc struct {
	health.UnimplementedHealthServer
}

func (g HealthSrvc) Check(ctx context.Context, req *health.HealthCheckRequest) (*health.HealthCheckResponse, error) {

	return &health.HealthCheckResponse{
		Status: health.HealthCheckResponse_SERVING,
	}, nil
}

func (g HealthSrvc) Watch(req *health.HealthCheckRequest, ws health.Health_WatchServer) error {
	return nil
}
