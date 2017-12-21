import UIKit


/// Converts a generic element to `NSAttributedString`.  Should only be used if a specific converter is not found.
///
class GenericElementConverter: ElementConverter {
    
    let serializer = AttributedStringSerializer()
    
    // MARK: - ElementConverter
    
    func canConvert(element: ElementNode) -> Bool {
        return true
    }
    
    func convert(_ element: ElementNode, inheriting attributes: [AttributedStringKey: Any]) -> NSAttributedString {
        let content = NSMutableAttributedString()
        
        for child in element.children {
            let childContent = serializer.serialize(child, inheriting: attributes)
            content.append(childContent)
        }
        
        return content
    }
}

