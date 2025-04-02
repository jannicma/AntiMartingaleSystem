public struct StringPosition: Codable {
    let riskRate: String
    let initialMargin: String
    let positionSide: String
    let margin: String
    let leverage: Int
    let availableAmt: String
    let maxMarginReduction: String
    let currency: String
    let updateTime: Int
    let avgPrice: String
    let positionValue: String
    let positionAmt: String
    let isolated: Bool
    let pnlRatio: String
    let liquidationPrice: Double
    let symbol: String
    let realisedProfit: String
    let unrealizedProfit: String
    let onlyOnePosition: Bool
    let positionId: String
    let markPrice: String
    let createTime: Int
}


public struct PositionResponse: Codable {
    let code: Int
    let msg: String?
    let timestamp: Int?
    let data: [StringPosition]?
}

