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
    
    
    func calculateVWAP(candles: [Candle]) -> Double {
        var sumPriceVolume = 0.0
        var sumVolume = 0.0
        for candle in candles {
            let typicalPrice = (candle.high + candle.low + candle.close) / 3.0
            sumPriceVolume += typicalPrice * candle.volume
            sumVolume += candle.volume
        }
        guard sumVolume != 0 else {
            return 0.0
        }
        return sumPriceVolume / sumVolume
    }
}
