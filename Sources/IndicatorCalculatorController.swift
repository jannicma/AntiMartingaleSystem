import Foundation

struct IndicatorCalculatorController {
    func calculateAtr(for data: [Candle]) -> Double {
        var atr: Double = 0
        for candle in data {
            let range = candle.high - candle.low
            atr += range
        }
        
        return atr / Double(data.count)
    }
}
