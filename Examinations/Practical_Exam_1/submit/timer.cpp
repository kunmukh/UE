// File: timer.cpp
// Definition of the Timer class operations
//
// ----------------------------------------------------------------------
// Class: CS 215                      
// Assignment: Programming Practical Exam 1, Problem 2
// Programmer: FILL IN YOUR NAME HERE!!
// Date: February 14 & 15, 2017

#include "timer.h"

Timer::Timer()
{
   minutes = 0;
   seconds = 0;
}

void Timer::Initialize (int newMinutes, int newSeconds)
{
  minutes = newMinutes;
  seconds = newSeconds;
}

void Timer::Tick()
{
  if (seconds == 0 && minutes == 0)
    {
      minutes = minutes ;
      seconds = seconds ;
    }
  
  if (seconds == 0 && minutes != 0)
    {
      
      minutes = minutes - 1;
      seconds = seconds + 60;
      seconds = seconds -1;
    }
  
  else
    seconds = seconds - 1;
}

RelationType Timer::ComparedTo(Timer rhs)
{
  if (minutes > rhs.minutes)
    return GREATER;
  if (minutes < rhs.minutes)
    return LESS;
  if (seconds > rhs.seconds)
    return GREATER;
  if (seconds < rhs.seconds)
    return LESS;

  else return EQUAL;
}

std::ostream& operator<< (std::ostream &out, Timer time)
{
  if ((time.minutes < 10) && (time.seconds < 10))
    {
      out << "0" << time.minutes << ":" << "0" << time.seconds;
    }

  else if ((time.minutes < 10) && (time.seconds > 10))
    {
      out << "0" << time.minutes << ":"  << time.seconds;
    }

  else if ((time.minutes > 10) && (time.seconds < 10))
    {
      out <<  time.minutes << ":" << "0"  << time.seconds;
    }
  
  else if
    {
      out << time.minutes << ":" << time.seconds ;
    }
  return out;
}

std::istream& operator>> (std::istream &in, Timer& time)
{
  in >> time.minutes >> time.seconds;
}

int Timer::GetMinutes() const
{
   return minutes;
}

int Timer::GetSeconds() const
{
   return seconds;
}

