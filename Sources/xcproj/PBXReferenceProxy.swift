import Foundation

/// A proxy for another object which might belong to another project
/// contained in the same workspace of the document.
/// This class is referenced by PBXTargetDependency.
public class PBXReferenceProxy: PBXObject, Hashable {
    
    // MARK: - Attributes
    
    // Element file type
    public var fileType: String
    
    // Element path.
    public var path: String
    
    // Element remote reference.
    public var remoteRef: String
    
    // Element source tree.
    public var sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    public init(reference: String,
                fileType: String,
                path: String,
                remoteRef: String,
                sourceTree: PBXSourceTree) {
        self.fileType = fileType
        self.path = path
        self.remoteRef = remoteRef
        self.sourceTree = sourceTree
        super.init(reference: reference)
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case fileType
        case path
        case remoteRef
        case sourceTree
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fileType = try container.decode(.fileType)
        self.path = try container.decode(.path)
        self.remoteRef = try container.decode(.remoteRef)
        self.sourceTree = try container.decode(.sourceTree)
        try super.init(from: decoder)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXReferenceProxy,
                           rhs: PBXReferenceProxy) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.fileType == rhs.fileType &&
            lhs.path == rhs.path &&
            lhs.remoteRef == rhs.remoteRef &&
            lhs.sourceTree == rhs.sourceTree
    }
}

// MARK: - PBXReferenceProxy
extension PBXReferenceProxy: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXVariantGroup.isa))
        dictionary["fileType"] = .string(CommentedString(fileType))
        dictionary["path"] = .string(CommentedString(path))
        dictionary["remoteRef"] = .string(CommentedString(remoteRef, comment: "PBXContainerItemProxy"))
        dictionary["sourceTree"] = sourceTree.plist()
        return (key: CommentedString(self.reference, comment: path),
                value: .dictionary(dictionary))
    }
    
}