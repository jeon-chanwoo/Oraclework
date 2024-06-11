SELECT*
from employee;

select*
from department;
//3번
select dept_id, dept_title
from department;

SELECT emp_id, emp_name, salary
from employee;
//1번
select job_name
from job;
//2번
select *
from department;
//4번
select emp_name, email, phone, hire_date,salary
from employee;

//직원 테이블에서 사원명, 사원의 연봉(급여*12)조회
select emp_name, salary*12 as salary_year
from employee;

//직원 테이블에서 사원명, 급여, 보너스
select emp_name, salary, bonus*salary as bonus
from employee;

//직원 테이블에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉
select emp_name, salary, COALESCE(bonus, 0), salary*12+COALESCE(bonus, 0)*salary as ysalary
from employee;
//직원테이블에서 사원명, 입사일, 근무일수 표시
select emp_name, hire_date, TRUNC(sysdate - hire_date) as work_day 
from employee;
//별칭에 특수기호나 띄어쓰기가 들어가면 반드시 쌍타음표로 묶어줘야 함
select 
    emp_name as 사원명, 
    TO_CHAR(salary, 'FM999,999,999,999') || '원' as 월급, 
    TO_CHAR(salary * 12, 'FM999,999,999,999') || '원' as 연봉,
    COALESCE(TO_CHAR(bonus, 'FM9999990.0'),'0.0')||'%' as 보너스, 
    TO_CHAR(salary*12+COALESCE(bonus, 0)*salary, 'FM999,999,999,999') || '원' as "보너스 포함 연봉"
from employee;


select emp_name,salary,dept_code
from employee
where dept_code != 'D1'; 

select emp_name,salary,hire_date,salary*12 as 연봉
from employee
where salary >=3000000; 

select emp_name,salary,salary*12 as 연봉,dept_code
from employee
where salary*12 >=50000000; 

select emp_id,emp_name,job_code,ent_yn
from employee
where job_code != 'j3'; 

select emp_name,email
from employee
where email like '___#_%' ESCAPE '#';

select emp_name,hire_date
from employee
where emp_name like '%연';

select emp_name,phone
from employee
where phone not like '010%';

select emp_name,salary
from employee
where emp_name like '%하%' and salary >=2400000;

select dept_id, dept_title
from department
where dept_title like '%해외영업%';

select emp_name, bonus,job_code
from employee
where dept_code is null and bonus is not null;

select emp_name, manager_id,job_code
from employee
where manager_id is null and job_code is null;

select emp_id,emp_name, salary*12 as ysalary, COALESCE(TO_CHAR(bonus, 'FM9999990.0'),'0.0')||'%' as 보너스
from employee
where salary*12 >=30000000 and bonus is null;

select emp_id, emp_name, hire_date,job_code
from employee
where hire_date >= '95/01/01' and job_code is not null;

select emp_id, emp_name, salary,hire_date ,bonus
from employee
where (salary between 2000000 and 5000000) and hire_date>='01/01/01' and bonus is null;

select emp_id, emp_name, salary, salary*12*(1+bonus)
from employee
where salary*12*(1+bonus)is not null and emp_name like '%하%';

-- 1. JOB 테이블에서 모든 정보 조회
select *
from job;
-- 2. JOB 테이블에서 직급 이름 조회
select job_name
from job;
-- 3. DEPARTMENT 테이블에서 모든 정보 조회
select *
from DEPARTMENT;
-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select emp_name, email,phone,hire_date
from EMPLOYEE;
-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select hire_date,emp_name,salary
from EMPLOYEE;
-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회

select emp_name, salary*12 as ysalary, salary*12*(1+COALESCE(bonus, 0)) as asalary,(salary*12*(1+COALESCE(bonus, 0))-(salary*12*0.03)) as rsalary
from EMPLOYEE;
-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
select emp_name, salary,hire_date,phone
from EMPLOYEE
where job_code like 'J1';
-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select emp_name,salary,(salary*12*(1+COALESCE(bonus, 0))-(salary*12*0.03)),hire_date
from EMPLOYEE
where (salary*12*(1+COALESCE(bonus, 0))-(salary*12*0.03))>=50000000;
-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select *
from employee
where salary>=4000000 and job_code like 'J2';
-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select emp_name,job_code,hire_date
from employee
where hire_date>='02/01/01';
-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
select *
from employee
where hire_date between '90/01/01' and '01/01/01';
-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
select emp_name
from employee
where emp_name like '%연';
-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select emp_name,phone
from employee
where phone not like '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
select *
from employee
where (email like '____#_%' ESCAPE '#') 
    and (DEPT_CODE like 'D6' or DEPT_CODE like 'D9')
    and (hire_date between '90/01/01' and '00/12/01')
    and (salary>=2700000);

