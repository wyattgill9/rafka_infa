use tokio::sync::mpsc;
use std::sync::{Arc, Mutex};
use std::thread;

#[tokio::main]
async fn main() {
    let num_workers = 3;
    let (tx, rx) = mpsc::channel::<String>(100);

    tokio::spawn(async move {
        for i in 0..10 {
            let msg = format!("Message {}", i);
            tx.send(msg).await.expect("Failed to send message");
            println!("Produced: Message {}", i);
        }
    });

    let rx = Arc::new(Mutex::new(rx));
    let mut worker_threads = Vec::new();

    for i in 0..num_workers {
        let rx = Arc::clone(&rx);
        let handle = thread::spawn(move || {
            loop {
                let message = {
                    let mut rx = rx.lock().unwrap(); 
                    rx.blocking_recv().unwrap()  
                };
                println!("Worker {} processing: {}", i, message);
            }
        });
        worker_threads.push(handle);
    }

    for handle in worker_threads {
        handle.join().unwrap();
    }

    let new_worker_count = 5;
    println!("\nScaling up to {} workers...", new_worker_count);
    let (tx, rx) = mpsc::channel::<String>(100);

    tokio::spawn(async move {
        for i in 10..20 {
            let msg = format!("Message {}", i);
            tx.send(msg).await.expect("Failed to send message");
            println!("Produced: Message {}", i);
        }
    });

    let rx = Arc::new(Mutex::new(rx));
    let mut new_worker_threads = Vec::new();
    for i in 0..new_worker_count {
        let rx = Arc::clone(&rx);
        let handle = thread::spawn(move || {
            loop {
                let message = {
                    let mut rx = rx.lock().unwrap();  // Lock the Mutex mutably
                    rx.blocking_recv().unwrap()  // Call blocking_recv on the locked receiver
                };
                println!("Scaled Worker {} processing: {}", i, message);
            }
        });
        new_worker_threads.push(handle);
    }

    for handle in new_worker_threads {
        handle.join().unwrap();
    }

    println!("\nAll messages processed.");
}
