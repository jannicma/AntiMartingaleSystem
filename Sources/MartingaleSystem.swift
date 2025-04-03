import Foundation


actor MartingaleSystem {
    private var bingxApi: BingxApiController?
    private let indicatorCalculator = IndicatorCalculatorController()
    
    private var symbol: String?
    private var vwapStartTimestamp: Int?

    private var task: Task<Void, Never>?
    
    private var nextVwapLevel: Decimal = 0.0
    
    public func start(symbol: String, vwapStartTime: Date) async {
        guard task == nil || task?.isCancelled == true else {
            print("System is already running.")
            return
        }

        bingxApi = BingxApiController()

        self.symbol = symbol
        self.vwapStartTimestamp = Int(vwapStartTime.timeIntervalSince1970) * 1000
        
        task = Task {
            while !Task.isCancelled {
                await runSystem()
                try? await Task.sleep(nanoseconds: 30 * 1_000_000_000) // 30 seconds
            }
        }
    }
    
    
    public func stop() async {
        task?.cancel()
        print("\(localTime()) - System stopped.")
    }

    
    
    private func runSystem() async {
        print("running system...")
        guard let bingxApi else {
            print("Error creating API instance.")
            return
        }
        
        guard let symbol = symbol else {
            print("Error: No symbol specified.")
            return
        }
        
        guard let vwapStartTimestamp = vwapStartTimestamp else {
            print("Error: No vwapStartTimestamp specified.")
            return
        }
                
        do {
            let position = try await bingxApi.getTrades(for: symbol)
            
            let avgPrice: Decimal = tmpAvgPrice //position.avgPrice
            let posAmount: Decimal = tmpPosAmount //position.positionAmt
            let isLong = position.positionSide == "LONG"
            let positionId = position.positionId
            
            
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
            
            let candlesMinInterval: [Candle] = try await bingxApi.getKline(symbol: symbol, interval: minInterval, startTime: vwapStartTimestamp)
            let atr1mCandles = minInterval == "1m" ? candlesMinInterval : try await bingxApi.getKline(symbol: symbol, interval: "1m", limit: 30)

            let currPrice = candlesMinInterval.first!.close
            let atr = indicatorCalculator.calculateAtr(for: atr1mCandles)

            if nextVwapLevel == 0.0 {
                nextVwapLevel = avgPrice + (isLong ? atr : -atr)
            }

            let vwap = indicatorCalculator.calculateVWAP(candles: candlesMinInterval)

            if currPrice < vwap {
                await self.stop()
            }
            if (isLong ? vwap > nextVwapLevel : vwap < nextVwapLevel) {
                let addingAmount = if isLong {
                    posAmount * (vwap - avgPrice) / (currPrice - vwap)
                } else {
                    posAmount * (avgPrice - vwap) / (vwap - currPrice)
                }
                
                var roundedAmount = (addingAmount as NSDecimalNumber).doubleValue
                roundedAmount = round(roundedAmount / 10.0) * 10.0
                print("\(localTime()) - enter at \(currPrice) with volume \(roundedAmount)")
                
                simulateEntry(average: vwap, size: Decimal(roundedAmount))
                
                nextVwapLevel = vwap + (isLong ? atr : -atr)
            }

        }
        catch {
            print("Error: \(error)")
        }
    }
    
    var tmpAvgPrice: Decimal = 82500.0
    var tmpPosAmount: Decimal = 1.0
    
    private func simulateEntry(average: Decimal, size: Decimal){
        tmpAvgPrice = average
        tmpPosAmount += size
    }
    
    private func localTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current // Use local timezone
        let localTime = formatter.string(from: Date())
        return localTime
    }
    
}
