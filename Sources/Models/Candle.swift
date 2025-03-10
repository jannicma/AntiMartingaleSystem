//
//  Candle.swift
//  AntiMartingaleSystem
//
//  Created by Jannic Marcon on 10.03.2025.
//

public struct Candle: Codable {
    let timestamp: Int
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
}
