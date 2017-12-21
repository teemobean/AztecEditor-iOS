import UIKit


/// ElementConverters take an HTML Element that don't have a textual representation and return a special value to
/// represent it (e.g. `<img>` or `<video>`). To apply a style to a piece of text, use `AttributeFormatter`.
///
protocol ElementConverter {

    /// Converts an instance of ElementNode into a NSAttributedString.
    ///
    /// - Parameters:
    ///     - element: ElementNode that's about to be converted.
    ///     - inheritedAttributes: Attributes to be applied over the resulting string.
    ///
    /// - Returns: NSAttributedString instance, representing the received element.
    ///
    func convert(from element: ElementNode, inheriting attributes: [AttributedStringKey: Any]) -> NSAttributedString


    /// The special string that represents the element — usually `NSAttachmentCharacter`.
    ///
    /// - Parameter element: Element that should be represented by the replacement String.
    ///
    func specialString(for element: ElementNode, inheriting: [AttributedStringKey: Any]) -> NSAttributedString


    /// Returns an attachment representing the HTML element.
    ///
    /// - Parameters:
    ///     - representation: HTML element to turn into an attachment.
    ///     - inheritedAttributes: Attributes inherited from the parent element — to be turned into `extraAttributes` on the `Attachment` itself.
    ///
    /// - Returns: Attachment when appropriate, `nil` when there isn't a valid transformation into an Attachment.
    ///
    func attachment(from representation: HTMLRepresentation, inheriting attributes: [AttributedStringKey: Any]) -> NSTextAttachment?


    /// Returns a dictionary of extra attributes that should be added to the result of `specialString(for:_)`,
    /// e.g. a HTML representation. Conflicting keys will be overwritten with new values returned from this method.
    ///
    /// - Parameter representation: HTML element that the attributes should be created for.
    ///
    /// - Returns: Dictionary of extra attributes where applicable, nil otherwise.
    ///
    func extraAttributes(for representation: HTMLRepresentation, inheriting attributes: [AttributedStringKey: Any]) -> [AttributedStringKey: Any]


    /// Indicates whether the received element can be converted by the current instance, or not.
    ///
    func canConvert(element: ElementNode) -> Bool
}


extension ElementConverter {
    func convert(from element: ElementNode, inheriting attributes: [AttributedStringKey: Any]) -> NSAttributedString {
        let elementRepresentation = HTMLElementRepresentation(element)
        let representation = HTMLRepresentation(for: .element(elementRepresentation))

        var copiedAttributes = extraAttributes(for: representation, inheriting: attributes)

        guard let attachment = attachment(from: representation, inheriting: attributes) else {
            return specialString(for: element, inheriting: attributes)
        }

        copiedAttributes[.attachment] = attachment

        return specialString(for: element, inheriting: copiedAttributes)
    }

    /// Default implementation, element converters providing attachments should override this.
    func attachment(from representation: HTMLRepresentation, inheriting inheritedAttributes: [AttributedStringKey: Any]) -> NSTextAttachment? {
        return nil
    }

    func extraAttributes(for representation: HTMLRepresentation, inheriting attributes: [AttributedStringKey: Any]) -> [AttributedStringKey: Any] {
        return attributes
    }
}
