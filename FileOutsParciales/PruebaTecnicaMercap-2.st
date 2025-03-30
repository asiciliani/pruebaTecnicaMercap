!classDefinition: #TelephoneBillTest category: #PruebaTecnicaMercap!
TestCase subclass: #TelephoneBillTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:42:29'!
comments
	'No modelo como una linea llama a la otra (entiendo que excede lo pedido, que es solo facturar), por lo que seteo las llamadas desde los tests.'! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 18:57:45'!
test01UnusedLineIsBilledBasicFee

	self assert: TelephoneLine new totalDue equals: TelephoneLine basicMonthlyFee.! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:41:02'!
test02WeekDayWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine new.
	line2 := TelephoneLine new.
	callDuration := 2 * minute.
	line1 calls: line2 on: Monday at: 8:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayWorkHoursFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:41:10'!
test03WeekDayNonWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine new.
	line2 := TelephoneLine new.
	callDuration := 2 * minute.
	line1 calls: line2 on: Monday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayNonWorkHoursFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:41:14'!
test04WeekendLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine new.
	line2 := TelephoneLine new.
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekendHoursFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:46:10'!
test05NationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine from: 'Buenos Aires'.
	line2 := TelephoneLine from: 'Rosario'.
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine nationalFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:51:45'!
todo
	'- refactor isWorkableTime
	- tiempos de los tests en funcion de work hours definidas en telephoneline o algun lado (en vez de 8:00, workHourStart + 1 minute)
	- renombrar colabs de line agregandoles local'! !



!classDefinition: #TelephoneLine category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLine
	instanceVariableNames: 'weekDayWorkHoursTimeUsed weekDayNonWorkHoursTimeUsed weekEndTimeUsed region nationalTimeUsed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/29/2025 19:54:02'!
totalDue
	^TelephoneLine basicMonthlyFee + (weekDayWorkHoursTimeUsed * self class weekDayWorkHoursFee)
										+ (weekDayNonWorkHoursTimeUsed * self class weekDayNonWorkHoursFee)
										+ (weekEndTimeUsed * self class weekendHoursFee)
										+ (nationalTimeUsed * self class nationalFee).! !


!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/29/2025 19:50:52'!
calls: aLineThatWasCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration 
	(aLineThatWasCalled isFrom: region) ifTrue: [
		aDayOfTheWeek isWeekDay ifTrue: [
		((8:00 <= aTimeOfDay) and: [aTimeOfDay <= (20:00)]) ifTrue: [^weekDayWorkHoursTimeUsed := weekDayWorkHoursTimeUsed + aCallDuration.].
		weekDayNonWorkHoursTimeUsed := weekDayNonWorkHoursTimeUsed + aCallDuration. ]
		ifFalse: [weekEndTimeUsed := weekEndTimeUsed + aCallDuration].]
	ifFalse: [nationalTimeUsed := nationalTimeUsed + aCallDuration].
	! !

!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/29/2025 19:51:27'!
initialize
	weekDayWorkHoursTimeUsed := 0 * minute.
	weekDayNonWorkHoursTimeUsed := 0 * minute.
	weekEndTimeUsed  := 0 * minute.
	nationalTimeUsed := 0 * minute.
	! !


!TelephoneLine methodsFor: 'instance creation' stamp: 'AS 3/29/2025 19:47:13'!
initializeFrom: aCallingRegion 
	region := aCallingRegion.! !


!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/29/2025 19:52:26'!
isFrom: aRegion 
	^region = aRegion.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TelephoneLine class' category: #PruebaTecnicaMercap!
TelephoneLine class
	instanceVariableNames: ''!

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 18:55:35'!
basicMonthlyFee
	^10 * dollar! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 19:47:57'!
nationalFee
	^14 * dollar / minute.! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 19:06:34'!
weekDayNonWorkHoursFee
	^0.1 * dollar / minute! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 18:53:01'!
weekDayWorkHoursFee
	^0.2 * dollar / minute! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 19:24:39'!
weekendHoursFee
	^0.12 * dollar / minute! !


!TelephoneLine class methodsFor: 'instance creation' stamp: 'AS 3/29/2025 19:46:53'!
from: aCallingRegion 
	^self new initializeFrom: aCallingRegion ! !
