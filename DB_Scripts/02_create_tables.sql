-- 2. Connect to the database and transfer ownership of the public schema (required for PostgreSQL 15+)
ALTER SCHEMA public OWNER TO vr_admin;

-- 1. Create roles
/* CREATE TABLE roles (
    role_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE -- admin, manager, tester, developer 
);*/

-- 2. Users
CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    birth_date DATE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    role_id INT NOT NULL, -- admin, manager, tester, developer
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW() /*,    
    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id) REFERENCES roles (role_id)
        ON DELETE RESTRICT*/
);

-- 3. Organizations
CREATE TABLE organizations (
    organization_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    organization_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    representer_name VARCHAR(255),
    admin_id BIGINT,
    CONSTRAINT fk_organizations_admin
        FOREIGN KEY (admin_id) REFERENCES users (user_id)
        ON DELETE restrict
);

-- 4. Projects
CREATE TABLE projects (
    project_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    organization_id BIGINT NOT NULL,
    manager_id BIGINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),  
    status VARCHAR(100),  -- active, completed
    CONSTRAINT fk_projects_organization
        FOREIGN KEY (organization_id) REFERENCES organizations (organization_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_projects_manager
        FOREIGN KEY (manager_id) REFERENCES users (user_id)
        ON DELETE restrict
);

-- 5. Tests
CREATE TABLE tests (
    testing_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    testing_name VARCHAR(255) NOT NULL,
    project_id BIGINT NOT NULL,
    tester_id BIGINT,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status VARCHAR(100), -- opened, in progress, closed, reopened
    CONSTRAINT fk_testing_project
        FOREIGN KEY (project_id) REFERENCES projects (project_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_testing_tester
        FOREIGN KEY (tester_id) REFERENCES users (user_id)
        ON DELETE restrict
);

-- 6. Solutions
CREATE TABLE solutions (
    solution_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    solution_name VARCHAR(255) NOT NULL,
    testing_id BIGINT,
    developer_id BIGINT,
    solution TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    status VARCHAR(100),  -- in progress, resolved
    CONSTRAINT fk_solutions_testing
        FOREIGN KEY (testing_id) REFERENCES tests (testing_id)
        ON DELETE cascade,
    CONSTRAINT fk_solutions_developer
        FOREIGN KEY (developer_id) REFERENCES users (user_id)
        ON DELETE restrict
)