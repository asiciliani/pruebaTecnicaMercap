!classDefinition: #TelephoneBillingTest category: #PruebaTecnicaMercap!
TestCase subclass: #TelephoneBillingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:54:54'!
arbitraryTimeOfDay

	^ 9:02! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/29/2025 20:10:48'!
test01UnusedLineIsBilledBasicFee

	self assert: (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina') totalDue equals: TelephoneLine basicMonthlyFee.! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:53:08'!
test02WeekDayWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	callDuration := 2 * minute.
	line1 calls: line2 on: Monday at: (LocalCallBiller workingHoursStart next: 1 * minute) for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayWorkHoursFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:53:50'!
test03WeekDayNonWorkHoursLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	callDuration := 2 * minute.
	line1 calls: line2 on: Monday at: (LocalCallBiller workingHoursStart previous:  1 * minute) for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekDayNonWorkHoursFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:54:54'!
test04WeekendLocalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	line2 := (TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina').
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: self arbitraryTimeOfDay for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine weekendHoursFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:54:54'!
test05NationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina'.
	line2 := TelephoneLine fromRegion: 'Rosario' in: 'Argentina'.
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: self arbitraryTimeOfDay for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine nationalFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 01:54:54'!
test06InternationalCallIsBilledCorrectly
	
	| line1 line2 callDuration |
	line1 := TelephoneLine fromRegion: 'Buenos Aires' in: 'Argentina'.
	line2 := TelephoneLine fromRegion: 'Montevideo' in: 'Uruguay'.
	callDuration := 2 * minute.
	line1 calls: line2 on: Saturday at: self arbitraryTimeOfDay for: callDuration.
	
	self assert: line1 totalDue equals: (TelephoneLine basicMonthlyFee ) + ((TelephoneLine internationalFee) * callDuration).! !

!TelephoneBillingTest methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 02:05:59'!
toDo
	'
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


!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:14:38'!
isInternational

	^ (callee isFromSameCountryAs: caller) not! !

!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:13:35'!
isLocal

	^ (callee isFromSameCountryAs: caller) and: [(callee isFromSameRegionAs: caller)]! !

!Call methodsFor: 'querying' stamp: 'AS 3/30/2025 01:14:22'!
isNational

	^ (callee isFromSameCountryAs: caller) and: [(callee isFromSameRegionAs: caller) not]! !


!Call methodsFor: 'duration' stamp: 'AS 3/30/2025 01:39:50'!
duration
	^duration ! !


!Call methodsFor: 'caller' stamp: 'AS 3/30/2025 18:08:36'!
caller
	^caller! !


!Call methodsFor: 'day' stamp: 'AS 3/30/2025 18:20:07'!
dayOfTheWeek
	^dayOfTheWeek! !


!Call methodsFor: 'time' stamp: 'AS 3/30/2025 01:48:56'!
timeOfDay
	^timeOfDay ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: #PruebaTecnicaMercap!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'instance creation' stamp: 'AS 3/29/2025 23:40:36'!
from: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration
	^self new initializeFrom: aCallingLine to: aLineThatIsCalled on: aDayOfTheWeek at: aTimeOfDay for: aCallDuration ! !


!classDefinition: #CallBiller category: #PruebaTecnicaMercap!
Object subclass: #CallBiller
	instanceVariableNames: 'call'
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

!CallBiller class methodsFor: 'instance creation' stamp: 'AS 3/30/2025 01:59:52'!
for: aCallToBill
	^(self allSubclasses detect: [:aSubclass | aSubclass canHandle: aCallToBill]) new initializeFor: aCallToBill.! !


!CallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 01:56:32'!
canHandle: aCallToBill 
	self subclassResponsibility ! !


!classDefinition: #InternationalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #InternationalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!InternationalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:08:20'!
cost
	^call duration * call caller class internationalFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternationalCallBiller class' category: #PruebaTecnicaMercap!
InternationalCallBiller class
	instanceVariableNames: ''!

!InternationalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 01:57:11'!
canHandle: aCallToBill
	^aCallToBill isInternational.! !


!classDefinition: #LocalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #LocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!LocalCallBiller methodsFor: 'billing' stamp: 'AS 3/30/2025 18:18:31'!
cost
	self subclassResponsibility ! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LocalCallBiller class' category: #PruebaTecnicaMercap!
LocalCallBiller class
	instanceVariableNames: ''!

!LocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:18:02'!
canHandle: aCallToBill
	^false! !


!LocalCallBiller class methodsFor: 'working hours' stamp: 'AS 3/30/2025 01:49:56'!
workingHoursEnd

	^ 20:00! !

!LocalCallBiller class methodsFor: 'working hours' stamp: 'AS 3/30/2025 01:49:59'!
workingHoursStart

	^ 8:00! !


!LocalCallBiller class methodsFor: 'querying' stamp: 'AS 3/30/2025 18:20:57'!
isCallDuringWorkingHours: aCallToBill 
	^ (self workingHoursStart <= aCallToBill timeOfDay) and: [aCallToBill timeOfDay <= (self workingHoursEnd)]! !

!LocalCallBiller class methodsFor: 'querying' stamp: 'AS 3/30/2025 18:19:46'!
isCallOnAWeekDay: aCallToBill 
	^aCallToBill dayOfTheWeek isWeekDay! !


!classDefinition: #WeekDayNonWorkingHoursLocalCallBiller category: #PruebaTecnicaMercap!
LocalCallBiller subclass: #WeekDayNonWorkingHoursLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekDayNonWorkingHoursLocalCallBiller methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 18:12:30'!
cost

	^call duration * call caller class  weekDayNonWorkHoursFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekDayNonWorkingHoursLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekDayNonWorkingHoursLocalCallBiller class
	instanceVariableNames: ''!

!WeekDayNonWorkingHoursLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:16:49'!
canHandle: aCallToBill
	^aCallToBill isLocal and: [(self isCallOnAWeekDay: aCallToBill) and: [(self isCallDuringWorkingHours: aCallToBill) not ] ].! !


!classDefinition: #WeekDayWorkingHoursLocalCallBiller category: #PruebaTecnicaMercap!
LocalCallBiller subclass: #WeekDayWorkingHoursLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekDayWorkingHoursLocalCallBiller methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 18:11:57'!
cost

	^call duration * call caller class weekDayWorkHoursFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekDayWorkingHoursLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekDayWorkingHoursLocalCallBiller class
	instanceVariableNames: ''!

!WeekDayWorkingHoursLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:16:14'!
canHandle: aCallToBill
	^aCallToBill isLocal and: [(self isCallOnAWeekDay: aCallToBill) and: [self isCallDuringWorkingHours: aCallToBill ] ].! !


!classDefinition: #WeekendLocalCallBiller category: #PruebaTecnicaMercap!
LocalCallBiller subclass: #WeekendLocalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!WeekendLocalCallBiller methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 18:12:41'!
cost

	^call duration * call caller class weekendHoursFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeekendLocalCallBiller class' category: #PruebaTecnicaMercap!
WeekendLocalCallBiller class
	instanceVariableNames: ''!

!WeekendLocalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 18:17:24'!
canHandle: aCallToBill
	^aCallToBill isLocal and: [(self isCallOnAWeekDay: aCallToBill) not]! !


!classDefinition: #NationalCallBiller category: #PruebaTecnicaMercap!
CallBiller subclass: #NationalCallBiller
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!NationalCallBiller methodsFor: 'as yet unclassified' stamp: 'AS 3/30/2025 18:08:51'!
cost
	^call duration * call caller class nationalFee! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NationalCallBiller class' category: #PruebaTecnicaMercap!
NationalCallBiller class
	instanceVariableNames: ''!

!NationalCallBiller class methodsFor: 'handling' stamp: 'AS 3/30/2025 01:57:34'!
canHandle: aCallToBill
	^aCallToBill isNational.! !


!classDefinition: #TelephoneLine category: #PruebaTecnicaMercap!
Object subclass: #TelephoneLine
	instanceVariableNames: 'region country outgoingCalls'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PruebaTecnicaMercap'!

!TelephoneLine methodsFor: 'billing' stamp: 'AS 3/30/2025 18:06:35'!
totalDue
	^(outgoingCalls sum: [ :aCall | (CallBiller for: aCall) cost] ifEmpty: [0*dollar]) + self class basicMonthlyFee.! !


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
