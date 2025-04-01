public struct StringCandle: Codable {
    let time: Int
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
}

public struct KlineResponse: Codable {
    let code: Int
    let msg: String?
    let timestamp: Int?
    let data: [StringCandle]?
}
