//  KeePassium Password Manager
//  Copyright © 2018–2019 Andrei Popleteev <info@keepassium.com>
// 
//  This program is free software: you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 as published
//  by the Free Software Foundation: https://www.gnu.org/licenses/).
//  For commercial licensing, please contact the author.

import Foundation

protocol DataCipher {
    var uuid: UUID { get }
    var initialVectorSize: Int { get }
    var keySize: Int { get }
    var name: String { get }
    
    func initProgress() -> ProgressEx
    
    /// - Throws: `CryptoError`, `ProgressInterruption`
    func encrypt(plainText: ByteArray, key: ByteArray, iv: ByteArray) throws -> ByteArray
    /// - Throws: `CryptoError`, `ProgressInterruption`
    func decrypt(cipherText: ByteArray, key: ByteArray, iv: ByteArray) throws -> ByteArray
    
    /// Create a compatibly-sized cipher key from the given key
    func resizeKey(key: ByteArray) -> SecureByteArray
}

extension DataCipher {
    
    /// Create a compatibly-sized cipher key from the given key
    func resizeKey(key: ByteArray) -> SecureByteArray {
        assert(key.count > 0)
        assert(keySize >= 0)
        
        if keySize == 0 {
            return SecureByteArray(ByteArray(count: 0))
        }
        
        let hash = (keySize <= 32) ? key.sha256 : key.sha512
        if hash.count == keySize {
            return SecureByteArray(hash)
        }
        
        if keySize < hash.count {
            return SecureByteArray(hash.prefix(keySize))
        } else {
            //TODO: not needed for current ciphers (AES, ChaCha20), but implement this for future
            fatalError("Not implemented")
        }
    }
}
