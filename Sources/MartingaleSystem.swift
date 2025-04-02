import Foundation


actor MartingaleSystem {
    private var bingxApi: BingxApiController?
    private let indicatorCalculator = IndicatorCalculatorController()
    
    private var symbol: String?
    private var vwapStartTimestamp: Int?

    private var task: Task<Void, Never>?
    
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
    
    
    public func stop() {
        task?.cancel()
        print("System stopped.")
    }

    
    
    private func runSystem() async {
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
                
        var nextVWAPLevel: Decimal = 0.0
        do {
            let position = try await bingxApi.getTrades(for: symbol)
            
            let avgPrice = position.avgPrice
            let posAmount = position.positionAmt
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
            let atr5mCandles = minInterval == "5m" ? candlesMinInterval : try await bingxApi.getKline(symbol: symbol, interval: "5m", limit: 20)

            let currPrice = candlesMinInterval.last!.close
            let atr = indicatorCalculator.calculateAtr(for: atr5mCandles)
            nextVWAPLevel = avgPrice - (isLong ? atr : -atr)

            let vwap = indicatorCalculator.calculateVWAP(candles: candlesMinInterval)

            if (isLong ? vwap > nextVWAPLevel : vwap < nextVWAPLevel) {
                let addingAmount = ((avgPrice * posAmount) - (vwap * posAmount)) / (vwap - currPrice)
                print("\(Date()): enter at \(currPrice) with volume \(addingAmount)")
            }

        }
        catch {
            print("Error: \(error)")
        }
    }
    
}
