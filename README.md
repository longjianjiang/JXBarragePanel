# JXBarragePanel
One barrage panel that allow you define barrage display style.

# Usage
you should create a barrage node conform `JXBarrageNodeProtocol`, below is an example:

```swift
struct TextBarrageNode: JXBarrageNodeProtocol {
    func getBarrageNodeWidth() -> CGFloat {
        return str.widthWithFont(font: UIFont.systemFont(ofSize: 15))
    }
    func getBarrageNode() -> UIView {
        let label = UILabel()
        label.text = str
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.red
        return label
    }
    
    let str: String!
    init(barrageNode str: String) {
        self.str = str
    }
}
```

then just call add method:

```swift
let barragePanel = JXBarragePanel.init(panelSize: CGSize(width: 414, height: 200), barrageHeight: 30, barrageLineSpace: 10)
let node = TextBarrageNode.init(barrageNode: text)
barragePanel.add(barrage: node)
```

# Todo
- [ ] provide custom animation methods

# Contact
brucejiang5.7@gmail.com

# License
MIT