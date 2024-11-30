// client.rs
use tonic::transport::Channel;
use rafka::rafka_client::RafkaClient;
use rafka::{CreateNodeRequest, ProduceEventRequest, RemoveNodeRequest, DemandEventRequest};

pub mod rafka {
    tonic::include_proto!("rafka");
}

#[tokio::main]
async fn main() {
    let mut client = RafkaClient::connect("http://127.0.0.1:50051")
        .await
        .unwrap();

    // Create a node
    let create_node_request = tonic::Request::new(CreateNodeRequest {
        node_name: "node1".to_string(),
        total_disk_size: 1024,
        buffer_capacity: 256,
    });

    let response = client.create_node(create_node_request).await.unwrap();
    println!("Create node response: {:?}", response);

    // Produce an event
    let produce_event_request = tonic::Request::new(ProduceEventRequest {
        node_name: "node1".to_string(),
        event: "event1".to_string(),
    });

    let response = client.produce_event(produce_event_request).await.unwrap();
    println!("Produce event response: {:?}", response);

    // Demand events
    let demand_event_request = tonic::Request::new(DemandEventRequest {
        node_name: "node1".to_string(),
        num: 2,
    });

    let response = client.demand_event(demand_event_request).await.unwrap();
    println!("Demand events response: {:?}", response);
}
