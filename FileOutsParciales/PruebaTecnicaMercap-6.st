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

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 23:44:32'!
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

!TelephoneBillTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 23:47:25'!
todo
	'- refactor isWorkableTime
	- tiempos de los tests en funcion de work hours definidas en telephoneline o algun lado (en vez de 8:00, workHourStart + 1 minute)
	- renombrar colabs de line agregandoles local
	- mejorar la rep del dia en que se llama (que sea una fecha completa y pueda elegir si es weekday o weekend)'! !



!classDefinition: #Call category: #PruebaTecnicaMercap!
Object subclass: #Call
	instanceVariableNames: 'caller callee dayOfTheWeek timeOfDay duration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!Call methodsFor: 'instance creation' stamp: 'AS 3/30/2025 01:39:50'!
initializeFrom: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration 
	caller := aCallingLine.
	callee := aLineThatIsCalled.
	dayOfTheWeek := aDayOfTheWeek.
	timeOfDay := aTimeOfDay.
	duration := aCallDuration.! !


!Call methodsFor: 'billing' stamp: 'AS 3/30/2025 01:15:59'!
isDuringWorkingHours

	^ (8:00 <= timeOfDay) and: [timeOfDay <= (20:00)]! !

!Call methodsFor: 'billing' stamp: 'AS 3/30/2025 01:14:38'!
isInternational

	^ (callee isFromSameCountryAs: caller) not! !

!Call methodsFor: 'billing' stamp: 'AS 3/30/2025 01:13:35'!
isLocal

	^ (callee isFromSameCountryAs: caller) and: [(callee isFromSameRegionAs: caller)]! !

!Call methodsFor: 'billing' stamp: 'AS 3/30/2025 01:14:22'!
isNational

	^ (callee isFromSameCountryAs: caller) and: [(callee isFromSameRegionAs: caller) not]! !


!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:39:17'!
isOnAWeekDay
	^dayOfTheWeek isWeekDay! !


!Call methodsFor: 'duration' stamp: 'AS 3/30/2025 01:39:50'!
duration
	^duration ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: #PruebaTecnicaMercap!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'instance creation' stamp: 'AS 3/29/2025 23:40:36'!
from: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration
	^self new initializeFrom: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration ! !


!classDefinition: #CallBiller category: #PruebaTecnicaMercap!
Object subclass: #CallBiller
	instanceVariableNames: 'call callToBill'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!CallBiller methodsFor: 'instance creation' stamp: 'AS 3/30/2025 01:33:57'!
initializeFor: aCallToBill 
	call := aCallToBill.! !


!CallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 01:34:16'!
cost
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CallBiller class' category: #PruebaTecnicaMercap!
CallBiller class
	instanceVariableNames: ''!

!CallBiller class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 01:33:19'!
for: aCallToBill
	(aCallToBill isLocal) ifTrue:[^LocalCallBiller new initializeFor: aCallToBill].
	(aCallToBill isNational) ifTrue:[^NationalCallBiller new initializeFor: aCallToBill].
	(aCallToBill isInternational) ifTrue:[^InternationalCallBiller new initializeFor: aCallToBill].! !


!classDefinition: #InternationalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #InternationalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!InternationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 01:40:46'!
cost
	^call duration * TelephoneLine internationalFee! !


!classDefinition: #LocalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #LocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!LocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 01:38:50'!
cost
	call isOnAWeekDay ifTrue: [
		call isDuringWorkingHours ifTrue: [^call duration * TelephoneLine weekDayWorkHoursFee]
								 ifFalse: [^call duration * TelephoneLine  weekDayNonWorkHoursFee]]
					    ifFalse: [^call duration * TelephoneLine weekendHoursFee].! !


!classDefinition: #NationalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #NationalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!NationalCallBiller methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:40:51'!
cost
	^call duration * TelephoneLine nationalFee! !


!classDefinition: #TelephoneLine category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLine
	instanceVariableNames: 'region country outgoingCalls'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 01:26:48'!
totalDue
	^(outgoingCalls sum: [ :aCall | (CallBiller for: aCall) cost] ifEmpty: [0*dollar]) + TelephoneLine basicMonthlyFee.! !


!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/30/2025 00:55:04'!
calls: aLineThatWasCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration
	outgoingCalls add: (Call from: self to: aLineThatWasCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration).! !

!TelephoneLine methodsFor: 'testing' stamp: 'AS 3/30/2025 00:55:25'!
initialize
	outgoingCalls  := OrderedCollection new
	! !


!TelephoneLine methodsFor: 'instance creation' stamp: 'AS 3/29/2025 20:12:06'!
initializeFromRegion: aCallingRegion in: aCallingCountry  
	region := aCallingRegion.
	country := aCallingCountry ! !


!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/30/2025 00:47:17'!
isFromSameCountryAs: aTelephoneLine 
	^country = aTelephoneLine country.! !

!TelephoneLine methodsFor: 'querying' stamp: 'AS 3/30/2025 00:47:49'!
isFromSameRegionAs: aTelephoneLine 
	^region = aTelephoneLine region! !


!TelephoneLine methodsFor: 'country' stamp: 'AS 3/30/2025 00:44:43'!
country
	^country! !


!TelephoneLine methodsFor: 'region' stamp: 'AS 3/30/2025 00:47:59'!
region
	^region! !

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
