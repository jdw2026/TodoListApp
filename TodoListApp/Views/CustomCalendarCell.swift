////
////  CustomCalendarCell.swift
////  TodoListApp
////
////  Created by 정다운 on 2024/07/03.
////

import UIKit
import FSCalendar

final class CustomCalendarCell: FSCalendarCell {

    var completionRate: Double? = nil {
        didSet {
            setNeedsDisplay()
        }
    }

    override init!(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        completionRate = nil
    }


    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let completionRate = completionRate else { return }
        //titleLabel의 프레임 가져오기
        guard let titleLabel = self.titleLabel else { return }
        let labelFrame = titleLabel.frame

        let labelCenter = CGPoint(x: labelFrame.midX, y: labelFrame.midY)
        let pathRadius = min(bounds.width, bounds.height) / 2.0 - 8.0
        let circleRadius = min(bounds.width, bounds.height) / 2.0 - 6.0
        let startAngle = -CGFloat.pi / 2.0
        let endAngle = startAngle + CGFloat.pi * 2.0 * CGFloat(completionRate)

        //완료율 100% -> 빨간색 동그라미
        if completionRate == 1.0 {

            let opaqueCircle = UIBezierPath(arcCenter: labelCenter, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            UIColor.red.setFill()
            opaqueCircle.fill()

        //완료율 0% 초과 -> 각 퍼센테이지에 맞는 원형 선
        }else if completionRate > 0.0 {

            //배경(반투명)
            let backgroundPath = UIBezierPath(arcCenter: labelCenter, radius: pathRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            UIColor.red.withAlphaComponent(0.2).setStroke()
            backgroundPath.lineWidth = 4.5 //두께
            backgroundPath.stroke()

            //완료율 그리기
            let foregroundPath = UIBezierPath(arcCenter: labelCenter, radius: pathRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            UIColor.red.setStroke()
            foregroundPath.lineWidth = 4.5
            foregroundPath.stroke()

        //완료율 0% -> 반투명 빨간색 원형 선
        } else if completionRate == 0.0 {
            
            let backgroundPath = UIBezierPath(arcCenter: labelCenter, radius: pathRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            UIColor.red.withAlphaComponent(0.2).setStroke()
            backgroundPath.lineWidth = 4.5 //두께
            backgroundPath.stroke()


//            let translucentCircle = UIBezierPath(arcCenter: labelCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//            UIColor.red.withAlphaComponent(0.2).setFill()
//            translucentCircle.fill()
        }

    }
}




