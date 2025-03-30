!classDefinition: #TelephoneBillTest category: #PruebaTecnicaMercap!
TestCase subclass: #TelephoneBillTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:42:29'!
comments
	'No modelo como una linea llama a la otra (entiendo que excede lo pedido, que es solo facturar), por lo que seteo las llamadas desde los tests.'! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test01UnusedLineIsBilledBasicFee

	self assert: (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina') totalDue equals: TelephoneLine basicMonthlyFee.! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test02WeekDayWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	callDuration := 2 * minute.
	line1 calls: line2 on: Monday at: 8:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayWorkHoursFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test03WeekDayNonWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	callDuration := 2 * minute.
	line1 calls: line2 on: Monday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayNonWorkHoursFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test04WeekendLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekendHoursFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test05NationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina'.
	line2 := TelephoneLine fromRegion: 'Rosario' in: 'Argentina'.
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine nationalFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test06InternationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina'.
	line2 := TelephoneLine fromRegion: 'Montevideo' in: 'Uruguay'.
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: 6:02 for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine internationalFee) * callDuration).! !

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 19:51:45'!
todo
	'- refactor isWorkableTime
	- tiempos de los tests en funcion de work hours definidas en telephoneline o algun lado (en vez de 8:00, workHourStart + 1 minute)
	- renombrar colabs de line agregandoles local'! !



!classDefinition: #TelephoneLine category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLine
	instanceVariableNames: 'weekDayWorkHoursTimeUsed weekDayNonWorkHoursTimeUsed weekEndTimeUsed region nationalTimeUsed country internationalTimeUsed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/29/2025 20:14:09'!
totalDue
	^TelephoneLine basicMonthlyFee + (weekDayWorkHoursTimeUsed * self class weekDayWorkHoursFee)
										+ (weekDayNonWorkHoursTimeUsed * self class weekDayNonWorkHoursFee)
										+ (weekEndTimeUsed * self class weekendHoursFee)
										+ (nationalTimeUsed * self class nationalFee)
										+ (internationalTimeUsed * self class internationalFee).! !


!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/29/2025 20:13:09'!
calls: aLineThatWasCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration
	(aLineThatWasCalled isFromCountry: country) ifTrue: [
		(aLineThatWasCalled isFromRegion: region) ifTrue: [
			aDayOfTheWeek isWeekDay ifTrue: [
			((8:00 <= aTimeOfDay) and: [aTimeOfDay <= (20:00)]) ifTrue: [^weekDayWorkHoursTimeUsed := weekDayWorkHoursTimeUsed + aCallDuration.].
			weekDayNonWorkHoursTimeUsed := weekDayNonWorkHoursTimeUsed + aCallDuration. ]
			ifFalse: [weekEndTimeUsed := weekEndTimeUsed + aCallDuration].]
		ifFalse: [nationalTimeUsed := nationalTimeUsed + aCallDuration]. ]
	ifFalse: [internationalTimeUsed := internationalTimeUsed + aCallDuration.]
	! !

!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/29/2025 20:09:50'!
initialize
	weekDayWorkHoursTimeUsed := 0 * minute.
	weekDayNonWorkHoursTimeUsed := 0 * minute.
	weekEndTimeUsed  := 0 * minute.
	nationalTimeUsed := 0 * minute.
	internationalTimeUsed := 0 * minute.
	! !


!TelephoneLine methodsFor: 'instance creation' stamp: 'AS 3/29/2025 20:12:06'!
initializeFromRegion: aCallingRegion in: aCallingCountry  
	region := aCallingRegion.
	country := aCallingCountry ! !


!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/29/2025 20:12:29'!
isFromCountry: aCountry 
	^country = aCountry ! !

!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/29/2025 20:10:04'!
isFromRegion: aRegion 
	^region = aRegion.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TelephoneLine class' category: #PruebaTecnicaMercap!
TelephoneLine class
	instanceVariableNames: ''!

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 18:55:35'!
basicMonthlyFee
	^10 * dollar! !

!TelephoneLine class methodsFor: 'fees' stamp: 'AS 3/29/2025 20:06:37'!
internationalFee
	^25 * dollar / minute! !

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


!TelephoneLine class methodsFor: 'instance creation' stamp: 'AS 3/29/2025 20:11:55'!
fromRegion: aCallingRegion in: aCallingCountry  
	^self new initializeFromRegion: aCallingRegion in: aCallingCountry ! !
