import Foundation

public struct Position: Codable, Sendable {
    let riskRate: Decimal
    let initialMargin: Decimal
    let positionSide: String
    let margin: Decimal
    let leverage: Int
    let availableAmt: Decimal
    let maxMarginReduction: Decimal
    let currency: String
    let updateTime: Int
    let avgPrice: Decimal
    let positionValue: Decimal
    let positionAmt: Decimal
    let isolated: Bool
    let pnlRatio: Decimal
    let liquidationPrice: Decimal
    let symbol: String
    let realisedProfit: Decimal
    let unrealizedProfit: Decimal
    let onlyOnePosition: Bool
    let positionId: Int
    let markPrice: Decimal
    let createTime: Int
    
    
    init(stringPosition: StringPosition){
        let zero: Decimal = 0.0
        
        self.riskRate = Decimal(string: stringPosition.riskRate) ?? zero
        self.initialMargin = Decimal(string: stringPosition.initialMargin) ?? zero
        self.positionSide = stringPosition.positionSide
        self.margin = Decimal(string: stringPosition.margin) ?? zero
        self.leverage = stringPosition.leverage
        self.availableAmt = Decimal(string: stringPosition.availableAmt) ?? zero
        self.maxMarginReduction = Decimal(string: stringPosition.maxMarginReduction) ?? zero
        self.currency = stringPosition.currency
        self.updateTime = stringPosition.updateTime
        self.avgPrice = Decimal(string: stringPosition.avgPrice) ?? zero
        self.positionValue = Decimal(string: stringPosition.positionValue) ?? zero
        self.positionAmt = Decimal(string: stringPosition.positionAmt) ?? zero
        self.isolated = stringPosition.isolated
        self.pnlRatio = Decimal(string: stringPosition.pnlRatio) ?? zero
        self.liquidationPrice = Decimal(string: "\(stringPosition.liquidationPrice)") ?? zero
        self.symbol = stringPosition.symbol
        self.realisedProfit = Decimal(string: stringPosition.realisedProfit) ?? zero
        self.unrealizedProfit = Decimal(string: stringPosition.unrealizedProfit) ?? zero
        self.onlyOnePosition = stringPosition.onlyOnePosition
        self.positionId = Int(stringPosition.positionId) ?? 0
        self.markPrice = Decimal(string: stringPosition.markPrice) ?? zero
        self.createTime = stringPosition.createTime
    }
}
