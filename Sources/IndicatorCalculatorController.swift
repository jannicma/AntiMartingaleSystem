import Foundation

struct IndicatorCalculatorController {
    func calculateAtr(for data: [Candle]) -> Decimal {
        var atr: Decimal = 0.0
        for candle in data {
            let range = candle.high - candle.low
            atr += range
        }
        
        return atr / Decimal(data.count)
    }
    
    
    func calculateVWAP(candles: [Candle]) -> Decimal {
        var sumPriceVolume: Decimal = 0.0
        var sumVolume: Decimal = 0.0
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
