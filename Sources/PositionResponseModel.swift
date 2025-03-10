import Foundation

struct PositionResponse: Codable {
    let info: PositionInfo
    let id: String
    let symbol: String
    let notional: Double
    let marginMode: String
    let liquidationPrice: Double?
    let entryPrice: Double
    let unrealizedPnl: Double
    let realizedPnl: Double
    let percentage: Double?
    let contracts: Double
    let contractSize: Double
    let markPrice: Double
    let lastPrice: Double?
    let side: String
    let hedged: Bool?
    let timestamp: Int?
    let datetime: String?
    let lastUpdateTimestamp: Int
    let maintenanceMargin: Double?
    let maintenanceMarginPercentage: Double?
    let collateral: Double?
    let initialMargin: Double
    let initialMarginPercentage: Double?
    let leverage: Double
    let marginRatio: Double?
    let stopLossPrice: Double?
    let takeProfitPrice: Double?
}

struct PositionInfo: Codable {
    let positionId: String
    let symbol: String
    let currency: String
    let positionAmt: String
    let availableAmt: String
    let positionSide: String
    let isolated: Bool
    let avgPrice: String
    let initialMargin: String
    let margin: String
    let leverage: String
    let unrealizedProfit: String
    let realisedProfit: String
    let liquidationPrice: String
    let pnlRatio: String
    let maxMarginReduction: String
    let riskRate: String
    let markPrice: String
    let positionValue: String
    let onlyOnePosition: Bool
    let updateTime: String
}

