import Foundation


actor MartingaleActor {
    private var bingxApi: BingxApiController?
    private let indicatorCalculator = IndicatorCalculatorController()
    
    private var runLoop: Bool = true

    public func startSystem(symbol: String, vwapStartTime: Date) async -> String {
        let vwapStartTimestamp = Int(vwapStartTime.timeIntervalSince1970 * 1000)

        bingxApi = BingxApiController()
        guard let bingxApi = bingxApi else {
            return ""
        }
        
        var nextVWAPLevel = 0.0
        
        while runLoop{
            let trade = bingxApi.getTradeBy(symbol: symbol)
            guard let trade = trade else {
                return ""
            }
            
            let avgPrice = Double(trade.info.avgPrice)!
            let posAmount = Double(trade.info.positionAmt)!
            let isLong = trade.info.positionSide == "LONG"
            let positionId = trade.info.positionId
            
            // calculate lowest possible timeframe to get all data (max 1000)
            let currentTimestamp: Int = Int(Date().timeIntervalSince1970 * 1000)
            let minutesSinceStart: Int = (currentTimestamp - vwapStartTimestamp) / 1000 / 60
            
            let minInterval: String = {
                switch minutesSinceStart {
                case ..<1000:
                    return "1m"
                case ..<5000:
                    return "5m"
                case ..<15000:
                    return "15m"
                default:
                    return "30m"
                }
            }()
            
            let candlesMinInterval: [Candle] = bingxApi.getCandles(symbol: symbol, since: vwapStartTimestamp, interval: minInterval)
            let atr5mCandles = minInterval == "5m" ? candlesMinInterval : bingxApi.getCandles(symbol: symbol, limit: 20, interval: "5m")
            let atr = indicatorCalculator.calculateAtr(for: atr5mCandles)
            nextVWAPLevel = avgPrice - (isLong ? atr : -atr)
            
            let vwap = indicatorCalculator.calculateVWAP(candles: candlesMinInterval)

            if (isLong ? vwap > nextVWAPLevel : vwap < nextVWAPLevel) {
                let addingAmount = 42.0 // vwap = ((currPrice * x) + (avgPrice * Size)) / (2 oder x + size)
                
            }
            
        }
        
        
        return "aaa"
    }
    
    
    public func stopSystem() {
        // will probably not work. Only idea for now
        runLoop = false
    }
}
