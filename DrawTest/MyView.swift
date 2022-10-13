import AppKit
import CoreText

class MyView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        var out = ""
        
        let a1 = NSMutableDictionary()
        a1[NSAttributedString.Key.strikethroughStyle.rawValue] = NSNumber(value: CTUnderlineStyle.thick.rawValue)
        a1[NSAttributedString.Key.underlineStyle.rawValue] = NSNumber(value: CTUnderlineStyle.thick.rawValue)
        drawStringA(name: 1, at: .init(x: 0, y: 5), attributes: a1 as CFDictionary, out: &out)
        drawStringB(name: 1, at: .init(x: 0, y: 22), attributes: a1 as CFDictionary, out: &out)

        let a2 = NSMutableDictionary()
        a2[NSAttributedString.Key.strikethroughStyle.rawValue] = CTUnderlineStyle.thick.rawValue
        a2[NSAttributedString.Key.underlineStyle.rawValue] = CTUnderlineStyle.thick.rawValue
        drawStringA(name: 2, at: .init(x: 0, y: 44), attributes: a2 as CFDictionary, out: &out)
        drawStringB(name: 2, at: .init(x: 0, y: 66), attributes: a2 as CFDictionary, out: &out)

        let a3 = NSMutableDictionary()
        a3[NSAttributedString.Key.underlineStyle.rawValue] = Int(CTUnderlineStyle.thick.rawValue)
        a3[NSAttributedString.Key.strikethroughStyle.rawValue] = Int(CTUnderlineStyle.thick.rawValue)
        drawStringA(name: 3, at: .init(x: 0, y: 88), attributes: a3 as CFDictionary, out: &out)
        drawStringB(name: 3, at: .init(x: 0, y: 110), attributes: a3 as CFDictionary, out: &out)
        
        if let storage = ((subviews.first as? NSScrollView)?.documentView as? NSTextView)?.textStorage {
            storage.beginEditing()
            storage.replaceCharacters(in: .init(location: 0, length: storage.length), with: out)
            storage.endEditing()
        }
    }
    
    func drawStringA(name: Int, at: CGPoint, attributes: CFDictionary, out: inout String) {
        let string = "A-\(name)"
        let cfString = string as CFString
        let cfStringLength = CFStringGetLength(cfString)
        let cfAttributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, cfStringLength)!
        
        CFAttributedStringBeginEditing(cfAttributedString)
        CFAttributedStringReplaceString(cfAttributedString, CFRange(location: 0, length: 0), cfString)
        CFAttributedStringSetAttributes(cfAttributedString, CFRange(location: 0, length: cfStringLength), attributes, false)
        CFAttributedStringEndEditing(cfAttributedString)
        
        let context = NSGraphicsContext.current!.cgContext

        context.saveGState()
        context.textMatrix = .identity
        
        let line = CTLineCreateWithAttributedString(cfAttributedString);
        context.textPosition = at
        CTLineDraw(line, context);
        context.restoreGState()
        
        out.append("\(cfAttributedString)\n")
    }
    
    func drawStringB(name: Int, at: CGPoint, attributes: CFDictionary, out: inout String) {
        let attributedString = NSAttributedString(string: "B-\(name)", attributes: attributes as? [NSAttributedString.Key : Any])
        attributedString.draw(at: at)
        out.append("\(attributedString)\n")
    }
    
}
