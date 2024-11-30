// server.rs
use tonic::{Request, Response, Status};
use std::sync::Arc;
use tokio::sync::RwLock;
use rafka::rafka_server::{Rafka, RafkaServer};
use rafka::{CreateNodeRequest, RemoveNodeRequest, ProduceEventRequest, DemandEventRequest, DemandEventReply, Empty};

pub mod rafka {
    tonic::include_proto!("rafka");
}

#[derive(Debug, Default)]
pub struct RafkaService {
    // This could represent the internal state of the service
    nodes: Arc<RwLock<Vec<String>>>,
}

#[tonic::async_trait]
impl Rafka for RafkaService {
    async fn create_node(&self, request: Request<CreateNodeRequest>) -> Result<Response<Empty>, Status> {
        let req = request.into_inner();
        let node_name = req.node_name;

        // Logic to create the node (e.g., store in some internal map or database)
        println!("Creating node: {}", node_name);

        let mut nodes = self.nodes.write().await;
        nodes.push(node_name);

        Ok(Response::new(Empty {}))
    }

    async fn remove_node(&self, request: Request<RemoveNodeRequest>) -> Result<Response<Empty>, Status> {
        let req = request.into_inner();
        let node_name = req.node_name;

        // Logic to remove the node
        println!("Removing node: {}", node_name);

        let mut nodes = self.nodes.write().await;
        if let Some(pos) = nodes.iter().position(|x| *x == node_name) {
            nodes.remove(pos);
        }

        Ok(Response::new(Empty {}))
    }

    async fn produce_event(&self, request: Request<ProduceEventRequest>) -> Result<Response<Empty>, Status> {
        let req = request.into_inner();
        let node_name = req.node_name;
        let event = req.event;

        // Logic to produce an event into the node's queue
        println!("Producing event '{}' for node: {}", event, node_name);

        Ok(Response::new(Empty {}))
    }

    async fn demand_event(&self, request: Request<DemandEventRequest>) -> Result<Response<DemandEventReply>, Status> {
        let req = request.into_inner();
        let node_name = req.node_name;
        let num = req.num;

        // Logic to demand events from the node's queue
        println!("Demanding {} events from node: {}", num, node_name);

        let events = vec!["event1".to_string(), "event2".to_string()]; // Replace with real logic

        Ok(Response::new(DemandEventReply { events }))
    }
}

pub async fn start_server() {
    let addr = "127.0.0.1:50051".parse().unwrap();
    let rafka_service = RafkaService::default();

    tonic::transport::Server::builder()
        .add_service(RafkaServer::new(rafka_service))
        .serve(addr)
        .await
        .unwrap();
}

