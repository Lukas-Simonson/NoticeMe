//
//  NoticeCancellation.swift
//  NoticeMe
//
//  Created by Lukas Simonson on 10/23/24.
//

extension NoticeInfo {
    public class Cancellation {
        var isUsed: Bool = false
        var cancellation: () -> Void
        
        init(cancellation: @escaping () -> Void) {
            self.cancellation = cancellation
        }
        
        public func callAsFunction() {
            cancel()
        }
        
        public func cancel() {
            guard !isUsed else { return }
            isUsed = true
            cancellation()
        }
    }
}
