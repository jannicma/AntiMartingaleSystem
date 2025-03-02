// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Main {
    static func main() async {
        print("Start...")
        
        let martingaleActor = MartingaleActor()
        _ = await martingaleActor.startSystem(tradeId: "", vwapStartTime: Date())
    }
}

