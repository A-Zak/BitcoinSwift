//
//  BlockTests.swift
//  BitcoinSwift
//
//  Created by Kevin Greene on 9/28/14.
//  Copyright (c) 2014 DoubleSha. All rights reserved.
//

import BitcoinSwift
import XCTest

class BlockTests: XCTestCase {

  let blockBytes: [UInt8] = [
      0x01, 0x00, 0x00, 0x00,                           // version
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // prev block
      0x3b, 0xa3, 0xed, 0xfd, 0x7a, 0x7b, 0x12, 0xb2,
      0x7a, 0xc7, 0x2c, 0x3e, 0x67, 0x76, 0x8f, 0x61,
      0x7f, 0xc8, 0x1b, 0xc3, 0x88, 0x8a, 0x51, 0x32,
      0x3a, 0x9f, 0xb8, 0xaa, 0x4b, 0x1e, 0x5e, 0x4a,   // merkle root
      0x29, 0xab, 0x5f, 0x49,                           // timestamp
      0xff, 0xff, 0x00, 0x1d,                           // bits
      0x1d, 0xac, 0x2b, 0x7c,                           // nonce
      0x01,                                             // number of transactions
      0x01, 0x00, 0x00, 0x00,                           // version
      0x01,                                             // 1 input (coinbase)
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0xff, 0xff, 0xff, 0xff,                           // prev output
      0x4d,                                             // script length
      0x04, 0xff, 0xff, 0x00, 0x1d, 0x01, 0x04, 0x45,
      0x54, 0x68, 0x65, 0x20, 0x54, 0x69, 0x6d, 0x65,
      0x73, 0x20, 0x30, 0x33, 0x2f, 0x4a, 0x61, 0x6e,
      0x2f, 0x32, 0x30, 0x30, 0x39, 0x20, 0x43, 0x68,
      0x61, 0x6e, 0x63, 0x65, 0x6c, 0x6c, 0x6f, 0x72,
      0x20, 0x6f, 0x6e, 0x20, 0x62, 0x72, 0x69, 0x6e,
      0x6b, 0x20, 0x6f, 0x66, 0x20, 0x73, 0x65, 0x63,
      0x6f, 0x6e, 0x64, 0x20, 0x62, 0x61, 0x69, 0x6c,
      0x6f, 0x75, 0x74, 0x20, 0x66, 0x6f, 0x72, 0x20,
      0x62, 0x61, 0x6e, 0x6b, 0x73,                     // script signature
      0xff, 0xff, 0xff, 0xff,                           // sequence
      0x01,                                             // 1 output
      0x00, 0xf2, 0x05, 0x2a, 0x01, 0x00, 0x00, 0x00,   // 50 BTC
      0x43,                                             // script length
      0x41, 0x04, 0x67, 0x8a, 0xfd, 0xb0, 0xfe, 0x55,
      0x48, 0x27, 0x19, 0x67, 0xf1, 0xa6, 0x71, 0x30,
      0xb7, 0x10, 0x5c, 0xd6, 0xa8, 0x28, 0xe0, 0x39,
      0x09, 0xa6, 0x79, 0x62, 0xe0, 0xea, 0x1f, 0x61,
      0xde, 0xb6, 0x49, 0xf6, 0xbc, 0x3f, 0x4c, 0xef,
      0x38, 0xc4, 0xf3, 0x55, 0x04, 0xe5, 0x1e, 0xc1,
      0x12, 0xde, 0x5c, 0x38, 0x4d, 0xf7, 0xba, 0x0b,
      0x8d, 0x57, 0x8a, 0x4c, 0x70, 0x2b, 0x6b, 0xf1,
      0x1d, 0x5f, 0xac,                                 // script
      0x00, 0x00, 0x00, 0x00]                           // lock time

  var blockData: NSData!
  var block: Block!

  override func setUp() {
    blockData = NSData(bytes: blockBytes, length: blockBytes.count)
    let previousBlockHashBytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    let previousBlockHash = SHA256Hash(bytes: previousBlockHashBytes)
    let merkleRootBytes: [UInt8] = [
        0x4a, 0x5e, 0x1e, 0x4b, 0xaa, 0xb8, 0x9f, 0x3a,
        0x32, 0x51, 0x8a, 0x88, 0xc3, 0x1b, 0xc8, 0x7f,
        0x61, 0x8f, 0x76, 0x67, 0x3e, 0x2c, 0xc7, 0x7a,
        0xb2, 0x12, 0x7b, 0x7a, 0xfd, 0xed, 0xa3, 0x3b]
    let merkleRoot = SHA256Hash(bytes: merkleRootBytes)
    let header = BlockHeader(version: 1,
                             previousBlockHash: previousBlockHash,
                             merkleRoot: merkleRoot,
                             timestamp: NSDate(timeIntervalSince1970: 1231006505),
                             compactDifficulty: 0x1d00ffff,
                             nonce: 0x7c2bac1d)
    let outPointTxHashBytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    let outPointTxHash = SHA256Hash(bytes: outPointTxHashBytes)
    let outPoint = Transaction.OutPoint(transactionHash: outPointTxHash, index: UInt32.max)
    let scriptSignatureBytes: [UInt8] = [
        0x04, 0xff, 0xff, 0x00, 0x1d, 0x01, 0x04, 0x45,
        0x54, 0x68, 0x65, 0x20, 0x54, 0x69, 0x6d, 0x65,
        0x73, 0x20, 0x30, 0x33, 0x2f, 0x4a, 0x61, 0x6e,
        0x2f, 0x32, 0x30, 0x30, 0x39, 0x20, 0x43, 0x68,
        0x61, 0x6e, 0x63, 0x65, 0x6c, 0x6c, 0x6f, 0x72,
        0x20, 0x6f, 0x6e, 0x20, 0x62, 0x72, 0x69, 0x6e,
        0x6b, 0x20, 0x6f, 0x66, 0x20, 0x73, 0x65, 0x63,
        0x6f, 0x6e, 0x64, 0x20, 0x62, 0x61, 0x69, 0x6c,
        0x6f, 0x75, 0x74, 0x20, 0x66, 0x6f, 0x72, 0x20,
        0x62, 0x61, 0x6e, 0x6b, 0x73]
    let scriptSignature = NSData(bytes: scriptSignatureBytes, length: scriptSignatureBytes.count)
    let inputs = [
        Transaction.Input(outPoint: outPoint,
                          scriptSignature: scriptSignature,
                          sequence: 0xffffffff)]
    let output0ScriptBytes: [UInt8] = [
        0x41, 0x04, 0x67, 0x8a, 0xfd, 0xb0, 0xfe, 0x55,
        0x48, 0x27, 0x19, 0x67, 0xf1, 0xa6, 0x71, 0x30,
        0xb7, 0x10, 0x5c, 0xd6, 0xa8, 0x28, 0xe0, 0x39,
        0x09, 0xa6, 0x79, 0x62, 0xe0, 0xea, 0x1f, 0x61,
        0xde, 0xb6, 0x49, 0xf6, 0xbc, 0x3f, 0x4c, 0xef,
        0x38, 0xc4, 0xf3, 0x55, 0x04, 0xe5, 0x1e, 0xc1,
        0x12, 0xde, 0x5c, 0x38, 0x4d, 0xf7, 0xba, 0x0b,
        0x8d, 0x57, 0x8a, 0x4c, 0x70, 0x2b, 0x6b, 0xf1,
        0x1d, 0x5f, 0xac]
    let output0Script = NSData(bytes: output0ScriptBytes, length: output0ScriptBytes.count)
    let outputs: [Transaction.Output] = [
        Transaction.Output(value: 5000000000, script: output0Script)]
    let transaction = Transaction(version: UInt32(1),
                                  inputs: inputs,
                                  outputs: outputs,
                                  lockTime: .AlwaysLocked)
    block = Block(header: header, transactions: [transaction])
  }

  func testBlockEncoding() {
    XCTAssertEqual(block.bitcoinData, blockData)
  }

  func testBlockDecoding() {
    let stream = NSInputStream(data: blockData)
    stream.open()
    if let testBlock = Block.fromBitcoinStream(stream) {
      XCTAssertEqual(testBlock, block)
    } else {
      XCTFail("Failed to parse Block")
    }
    XCTAssertFalse(stream.hasBytesAvailable)
    stream.close()
  }

  func testBlockHash() {
    let blockHashBytes: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0xd6, 0x68,
        0x9c, 0x08, 0x5a, 0xe1, 0x65, 0x83, 0x1e, 0x93,
        0x4f, 0xf7, 0x63, 0xae, 0x46, 0xa2, 0xa6, 0xc1,
        0x72, 0xb3, 0xf1, 0xb6, 0x0a, 0x8c, 0xe2, 0x6f]
    let blockHash = SHA256Hash(bytes: blockHashBytes)
    XCTAssertEqual(block.hash, blockHash)
  }
}
