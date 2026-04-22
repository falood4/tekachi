CREATE TABLE user_profile (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    full_name VARCHAR(255),

    class10_school VARCHAR(255),
    class10_board VARCHAR(255),
    class10_score VARCHAR(64),
    class10_year INT,

    class12_school VARCHAR(255),
    class12_board VARCHAR(255),
    class12_score VARCHAR(64),
    class12_year INT,

    ug_college VARCHAR(255),
    ug_degree VARCHAR(255),
    ug_score VARCHAR(64),
    ug_year INT,

    CONSTRAINT fk_user_profile_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE user_profile_skill (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    profile_id BIGINT NOT NULL,
    skill VARCHAR(255) NOT NULL,
    CONSTRAINT fk_user_profile_skill_profile FOREIGN KEY (profile_id) REFERENCES user_profile(id) ON DELETE CASCADE
);

CREATE TABLE user_profile_link (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    profile_id BIGINT NOT NULL,
    label VARCHAR(255),
    url VARCHAR(1024) NOT NULL,
    CONSTRAINT fk_user_profile_link_profile FOREIGN KEY (profile_id) REFERENCES user_profile(id) ON DELETE CASCADE
);
