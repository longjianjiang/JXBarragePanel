//
//  JXBarragePanel.swift
//  JXBarragePanel
//
//  Created by zl on 2018/9/25.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

import UIKit

private struct JXBarragePanelConstants {
    static let kBarrageMoveSpeed: CGFloat = 50.0
    static let kBarrageHorizontalSpace: CGFloat = 20.0
    static let kTryDisplayWaitBarragesInterval: TimeInterval = 1.0
}

public protocol JXBarrageNodeProtocol {
    /// this is factory method to get a barrage node
    ///
    /// - Returns: barrageNode to display in panel
    func getBarrageNode() -> UIView
    
    /// this method tell panel barrageNode's width
    ///
    /// - Returns: barrageNode's width
    func getBarrageNodeWidth() -> CGFloat
}

private struct JXBarrageItem {
    var barrageNodeRawData: JXBarrageNodeProtocol?
    var barrageId: Int?
    var barrageLine: Int?
    var barrageNode: UIView?
    
    
    init(barrageNodeRawData: JXBarrageNodeProtocol) {
        self.barrageNodeRawData = barrageNodeRawData
    }
    
    init(barrageId: Int, barrageLine: Int, barrageNode: UIView) {
        self.barrageId = barrageId
        self.barrageLine = barrageLine
        self.barrageNode = barrageNode
    }
}

public class JXBarragePanel: UIView {
    
    /// barrage node move speed, default is 50
    public var barrageMoveSpeed = JXBarragePanelConstants.kBarrageMoveSpeed
    
    /// barrage ndoe horizontal space when screen display more barrage node, default is 20
    public var barrageHorizontalSpace = JXBarragePanelConstants.kBarrageHorizontalSpace
    
    /// timer interval to try display wait barrage node, default is 1 second
    public var tryDisplayWaitBarragesInterval = JXBarragePanelConstants.kTryDisplayWaitBarragesInterval
    
    private var liveBarrages = [JXBarrageItem]()
    private var waitBarrages = [JXBarrageItem]()
    private var barrageIdBase: Int = 0
    private var timer: Timer!
    
    private let panelSize: CGSize
    private let barrageHeight: CGFloat
    private let barrageLineSpace: CGFloat
    private let lineCount: Int
    
    //MARK: life cycle
    
    /// create a barrage panel, use panel size height and barrage height & barrage line space to calculate barrage line count
    ///
    /// - Parameters:
    ///   - panelSize: panel size
    ///   - barrageHeight: barrage height
    ///   - barrageLineSpace: barrage line space
    required public init(panelSize: CGSize, barrageHeight: CGFloat, barrageLineSpace: CGFloat) {
        self.panelSize = panelSize
        self.barrageHeight = barrageHeight
        self.barrageLineSpace = barrageLineSpace
        self.lineCount = (Int)(panelSize.height / (barrageHeight + barrageLineSpace))
        
        super.init(frame: CGRect.zero)
        
        clipsToBounds = true
        
        setupTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        resetBarrage()
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            timer.invalidate()
        }
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: tryDisplayWaitBarragesInterval,
                                     target: self,
                                     selector: #selector(canSendWaitBarrage),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    //MARK: public method
    
    /// send a barrage item that conform protocol `JXBarrageItemProtocol`
    public func add(barrage aBarrage: JXBarrageNodeProtocol) {
        guard aBarrage.getBarrageNodeWidth() > 0 else {
            return
        }
        
        if addBarrageImplWithBarrage(aBarrage) == false {
            let waitItem = JXBarrageItem.init(barrageNodeRawData: aBarrage)
            waitBarrages.append(waitItem)
        }
    }
    
    /// reset barrage panel, remove all barrageNode
    public func resetBarrage() {
        waitBarrages.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    
    //MARK: impl method
    private func addBarrageImplWithBarrage(_ aBarrage: JXBarrageNodeProtocol) -> Bool {
        let line = getEmptyLine()
        if line == -1 {
            return false
        }
        
        let barrageNode = aBarrage.getBarrageNode()
        let barrageNodeWidth = aBarrage.getBarrageNodeWidth()
        barrageNode.frame = CGRect(x: panelSize.width,
                                   y: (CGFloat)(line) * (barrageHeight + barrageLineSpace) + barrageLineSpace,
                                   width: barrageNodeWidth,
                                   height: barrageHeight)
        addSubview(barrageNode)
        
        let barrageId = barrageIdBase
        barrageIdBase += 1
        let barrageItem = JXBarrageItem.init(barrageId: barrageId, barrageLine: line, barrageNode: barrageNode)
        liveBarrages.append(barrageItem)
        
        let moveTime = (TimeInterval)((panelSize.width + barrageNode.frame.size.width) / barrageMoveSpeed)
        UIView.animate(withDuration: moveTime, delay: 0.5, options: .curveLinear, animations: {
            barrageNode.frame.origin.x = -barrageNodeWidth
        }, completion: {finished in
            self.removeBarrageWithBarrageId(barrageId)
        })
        
        return true
    }
    
    /// get one empty line that did not have barrageNode
    private func getEmptyLine() -> Int {
        let start = (Int)(arc4random()) % (lineCount - 1)
        for i in 1..<lineCount {
            let line = (start + i) % lineCount
            if isLineEmpty(line) {
                return line
            }
        }
        
        return getAvailableLine()
    }
    
    /// judge this line whether have barrageNode
    private func isLineEmpty(_ line: Int) -> Bool {
        for item in liveBarrages {
            if let barrageLine = item.barrageLine, barrageLine == line {
                return false
            }
        }
        return true
    }
    
    /// get one available line that have space to display another barrageNode
    private func getAvailableLine() -> Int {
        let start = (Int)(arc4random()) % (lineCount - 1)
        for i in 1..<lineCount {
            let line = (start + i) % lineCount
            if isLineAvailable(line) {
                return line
            }
        }
        
        return -1
    }
    
    /// judge this line whether have space to display another barrageNode
    private func isLineAvailable(_ line: Int) -> Bool {
        for item in liveBarrages {
            if let barrageLine = item.barrageLine, barrageLine == line {
                if let barrageNode = item.barrageNode,
                    let barragePresentionLayer = barrageNode.layer.presentation(),
                    barragePresentionLayer.frame.origin.x > panelSize.width - barrageNode.frame.size.width - barrageHorizontalSpace {
                    return false
                }
            }
        }
        return true
    }
    
    /// remove one barrageNode when its not display in screen
    private func removeBarrageWithBarrageId(_ aId: Int) {
        var needDeleteBarrageItemIndex = -1
        for (index, item) in liveBarrages.enumerated() {
            if let barrageId = item.barrageId, barrageId == aId,
                let barrageNode = item.barrageNode {
                barrageNode.removeFromSuperview()
                needDeleteBarrageItemIndex = index
                break
            }
        }
        
        if needDeleteBarrageItemIndex >= 0 {
            liveBarrages.remove(at: needDeleteBarrageItemIndex)
        }
    }
    
    //MARK: timer method
    
    @objc private func canSendWaitBarrage() {
        guard waitBarrages.count > 0 else {
            return
        }
        
        let waitItem = waitBarrages.first!
        if let aBarrage = waitItem.barrageNodeRawData, addBarrageImplWithBarrage(aBarrage) {
            waitBarrages.removeFirst()
        }
    }
}
