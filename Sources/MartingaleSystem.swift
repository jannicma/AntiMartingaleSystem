import Foundation


class MartingaleSystem {
    private var bingxApi: BingxApiController?
    private let indicatorCalculator = IndicatorCalculatorController()
    
    private var timer: DispatchSourceTimer?
    private let timerQueue = DispatchQueue(label: "repeatingTask", qos: .background)
    
    
    private var symbol: String?
    private var vwapStartTimestamp: Int?

    
    public func start(symbol: String, vwapStartTime: Date) {
        bingxApi = BingxApiController()
        
        // Prevent starting multiple timers
        guard timer == nil else {
            print("System is already running.")
            return
        }
        
        self.symbol = symbol
        self.vwapStartTimestamp = Int(vwapStartTime.timeIntervalSince1970)
        
        timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timer?.schedule(deadline: .now(), repeating: 5.0, leeway: .milliseconds(500))
        timer?.setEventHandler { [weak self] in
            self?.runSystem()
        }
        
        timer?.resume()
        print("System running...")
    }

    
    
    private func runSystem() {
        guard let bingxApi = bingxApi else {
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
        
        print("count++")
        
        var nextVWAPLevel = 0.0
        
        let trade = bingxApi.getTradeBy(symbol: symbol)
        guard let trade = trade else {
            print("Error fetching trade data.")
            return
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
        let currPrice = candlesMinInterval.last!.close
        let atr = indicatorCalculator.calculateAtr(for: atr5mCandles)
        nextVWAPLevel = avgPrice - (isLong ? atr : -atr)
        
        let vwap = indicatorCalculator.calculateVWAP(candles: candlesMinInterval)
        
        if (isLong ? vwap > nextVWAPLevel : vwap < nextVWAPLevel) {
            let addingAmount = ((avgPrice * posAmount) - (vwap * posAmount)) / (vwap - currPrice)
            print("\(Date()): enter at \(currPrice) with volume \(addingAmount)")
        }
        
    }
    
    
    public func stop() {
        timer?.cancel()
        timer = nil
        print("System stopped.")
    }
}
